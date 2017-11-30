# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# jpp
# http://www.xyzpub.com/en/ruby-on-rails/3.2/seed_rb.html
# https://davidmles.com/seeding-database-rails/
# https://stackoverflow.com/questions/27931101/password-cant-be-blank-error-when-seeding-database
#
# Bryce says: use db:reset at rails console instead of destroying things manually in this file.
# https://piazza.com/class/j789lo09yai5qx?cid=56

# Update nov 29, 2017: If running in production, 

# 2 issues:
# 1. make EB seed upon deploy.
# 2. make this seed file do different things in production vs dev/test.


######################################
# MASS IMPORT

# https://swaac.tamouse.org/swaac/2013/09/03/mass-inserting-data-in-rails-without-killing-your-performance-coffeepowered/
# https://piazza.com/class/j789lo09yai5qx?cid=78

# require "ar-extensions"

#######################################

case Rails.env
  when 'test', 'development'
    puts 'in test or dev!'
    how_many = {user: 10, cars_per_user: 1, rentals_per_car: 3}
  when 'production'
    puts 'in production!'
    how_many = {user: 10, cars_per_user: 2, rentals_per_car: 10}
end





###############################################
# USERS
###############################################


# Example of direct SQL insertion from the web:
#
# TIMES = 10000
# inserts = []
# TIMES.times do
#   inserts.push "(3.0, '2009-01-23 20:21:13', 2, 1)"
# end
# sql = "INSERT INTO user_node_scores (`score`, `updated_at`, `node_id`, `user_id`) VALUES #{inserts.join(", ")}"
# CONN.execute sql


# # Minimum Working Example of inserting directly into SQL DB:
# #
# # User.column_names
# #=> ["id", "first_name", "last_name", "city", "state", "username", "email", "password_digest", "admin", "logged_in_at", "created_at", "updated_at"]
#
# d1 = { first_name: "Bob", last_name: "Jones", city: "Goleta", state: "CA", username: "skater41", email: "user1@boo.com", password: "foobar", admin: false, signed_in_at: "2017-11-27 20:32:15" }
# d2 = { first_name: "Justin", last_name: "Jones", city: "Goleta", state: "CA", username: "skater42", email: "user2@boo.com", password: "foobar", admin: false, signed_in_at: "2017-11-27 20:32:35" }
# inserts = []
# my_header = ''
# [d1,d2].each_with_index do |d,i|
#     d[:id] = i + 999
#     d[:created_at] = "2017-11-27 20:32:35"
#     d[:updated_at] = "2017-11-27 20:32:35"
#     if d[:admin]
#       d[:admin] = "TRUE"  
#     else 
#       d[:admin] = "FALSE"
#     end
#     d[:password_digest] = User.digest('foobar')
#     d.delete(:password)
#     my_header_elems = d.keys.map {|s| '`' + s.to_s + '`'}
#     my_header = my_header_elems.join(',')
#     strs = d.values.map {|e| e.inspect}
#     inserts.push( '(' +  strs.join(',') + ')')
#   end
# big_string = inserts.join(", ")
# sql = "INSERT INTO users (#{my_header}) VALUES #{big_string}"
#
# CONN = ActiveRecord::Base.connection
# CONN.execute sql

# User.column_names
# => ["id", "first_name", "last_name", "city", "state", 
#     "username", "email", "password_digest", "admin", 
#     "signed_in_at", "created_at", "updated_at"]

sql = "INSERT INTO users (#{(User.column_names.map {|s| "`#{s}`"}).join(',')}) VALUES "

how_many[:user].times do |i|

  d = { 
      id:           i,
      first_name:   "Bob",
      last_name:    "Jones",
      city:         "Goleta",
      state:        "CA",
      username:     "skater4#{i}",
      email:        "user#{i}@boo.com",
      password:     "foobar",
      admin:        false,
      signed_in_at: DateTime.now,
      created_at:   DateTime.now,
      updated_at:   DateTime.now
      }

  if i==1  # Make admin
    d.merge!  first_name:   "Mister",
              last_name:    "Admn",
              username:     "admin01",
              email:        "a@a.com",
              admin:        true
  end

  if Rails.env.production?
    d[:signed_in_at]    = d[:signed_in_at].strftime("%FT%T")
    d[:created_at]      = d[:created_at].strftime("%FT%T")
    d[:updated_at]      = d[:updated_at].strftime("%FT%T")
    d[:admin]           = d[:admin] ? "TRUE" : "FALSE"
    d[:password_digest] = User.digest(d[:password])
    vals = '(' + (d.values_at(*User.column_names.map {|s| s.to_sym}).map {|s| s.inspect}).join(',') + ')'
    sql += i==1 ? vals : ',' + vals
  else      
    d.delete(:id)
    d.delete(:created_at)
    d.delete(:updated_at)
    User.create!(d)
  end
  
end

if Rails.env.production?
  ActiveRecord::Base.connection.execute sql
end

p "Created #{User.count} users"


###############################################
# CARS
###############################################


#> Car.column_names
#=> ["id", "user_id", "make", "model", "year", "color", "license_plate", "created_at", "updated_at"]

car_makes = ['Toyota','Ford','Nissan','BMW','Mazda','Mercedes','Volkswagen','Audi','Kia','Hyundai','Subaru']
car_models = ['Civic','Accord','Camry','F-150','Wrangler','Highlander','Grand Cherokee','Tacoma','Outback','Forester',
  'Equinox','Explorer','Mustang','Camaro','Tacoma','Odyssey','Silverado','Escape','Corolla','Tahoe','Fusion','Charger']
car_colors = ['Red','Orange','Yellow','Green','Blue','Purple','Black','White','Gray','Silver']


sql = "INSERT INTO cars (#{(Car.column_names.map {|s| "`#{s}`"}).join(',')}) VALUES "
i = 0
User.all.each do |u|
  how_many[:cars_per_user].times do 
    p "Making a car for user #{u.username} (total cars: #{i+1})"
    d = {
      id:             (i+=1),
      user_id:        u.id,
      make:           car_makes.sample,
      model:          car_models.sample,
      year:           (1960..2017).to_a.sample,
      color:          car_colors.sample,
      license_plate:  [(0...9).to_a.sample, ('A'...'Z').to_a.sample(3), (0...9).to_a.sample(3)].join,
      created_at:     DateTime.now,
      updated_at:     DateTime.now
    }

    if Rails.env.production?
      d[:created_at]      = d[:created_at].strftime("%FT%T")
      d[:updated_at]      = d[:updated_at].strftime("%FT%T")
      vals = '(' + (d.values_at(*Car.column_names.map {|s| s.to_sym}).map {|s| s.inspect}).join(',') + ')'
      sql += i==1 ? vals : ',' + vals
    else      
      d.delete(:id)
      d.delete(:created_at)
      d.delete(:updated_at)
      Car.create!(d)
    end
  end
end

if Rails.env.production?
  ActiveRecord::Base.connection.execute sql
end

p "Created #{Car.count} cars"

###############################################
# Rentals
###############################################


# ["id", "owner_id", "renter_id", "renter_visible", "car_id", "status", "start_location", "start_longitude", 
#  "start_latitude", "end_location", "end_longitude", "end_latitude", "start_time", "end_time", "price", "terms", "created_at", "updated_at"]

all_locations = {
  "Los Angeles, CA"       => [34.0194, -118.411],
  "San Diego, CA"         => [32.8153, -117.135],
  "San Jose, CA"          => [37.2969, -121.819],
  "San Francisco, CA"     => [37.7599, -122.437],
  "Fresno, CA"            => [36.7827, -119.794],
  "Sacramento, CA"        => [38.5666, -121.469],
  "Long Beach, CA"        => [33.8091, -118.155],
  "Oakland, CA"           => [37.7699, -122.226],
  "Bakersfield, CA"       => [35.3212, -119.018],
  "Anaheim, CA"           => [33.8362, -117.890],
  "Santa Ana, CA"         => [33.7365, -117.883],
  "Riverside, CA"         => [33.9381, -117.393],
  "Stockton, CA"          => [37.9763, -121.313],
  "Chula Vista, CA"       => [32.6277, -117.015],
  "Irvine, CA"            => [33.6784, -117.771],
  "Fremont, CA"           => [37.4944, -121.941],
  "San Bernardino, CA"    => [34.1393, -117.295],
  "Modesto, CA"           => [37.6609, -120.989],
  "Oxnard, CA"            => [34.2023, -119.205],
  "Fontana, CA"           => [34.1088, -117.463],
  "Moreno Valley, CA"     => [33.9233, -117.206],
  "Huntington Beach, CA"  => [33.6906, -118.009],
  "Glendale, CA"          => [34.1814, -118.246],
  "Santa Clarita, CA"     => [34.4049, -118.505],
  "Garden Grove, CA"      => [33.7788, -117.960],
  "Oceanside, CA"         => [33.2246, -117.306],
  "Rancho Cucamonga, CA"  => [34.1233, -117.564],
  "Santa Rosa, CA"        => [38.4468, -122.706],
  "Ontario, CA"           => [34.0395, -117.609],
  "Elk Grove, CA"         => [38.4144, -121.385],
  "Corona, CA"            => [33.8624, -117.564],
  "Lancaster, CA"         => [34.6936, -118.175],
  "Palmdale, CA"          => [34.5913, -118.109],
  "Salinas, CA"           => [36.6902, -121.634],
  "Hayward, CA"           => [37.6281, -122.106],
  "Pomona, CA"            => [34.0586, -117.761],
  "Escondido, CA"         => [33.1336, -117.073],
  "Sunnyvale, CA"         => [37.3858, -122.026],
  "Torrance, CA"          => [33.8350, -118.341],
  "Pasadena, CA"          => [34.1606, -118.140],
  "Orange, CA"            => [33.8048, -117.825],
  "Fullerton, CA"         => [33.8857, -117.928],
  "Thousand Oaks, CA"     => [34.1933, -118.874],
  "Visalia, CA"           => [36.3272, -119.323],
  "Roseville, CA"         => [38.7657, -121.303],
  "Concord, CA"           => [37.9722, -122.002],
  "Simi Valley, CA"       => [34.2669, -118.748],
  "East Los Angeles, CA"  => [34.0315, -118.169],
  "Santa Clara, CA"       => [37.3646, -121.968],
  "Victorville, CA"       => [34.5277, -117.354],
  "Vallejo, CA"           => [38.1079, -122.264],
  "Berkeley, CA"          => [37.8667, -122.299],
  "El Monte, CA"          => [34.0746, -118.029],
  "Downey, CA"            => [33.9382, -118.131],
  "Costa Mesa, CA"        => [33.6659, -117.912],
  "Carlsbad, CA"          => [33.1239, -117.283],
  "Inglewood, CA"         => [33.9561, -118.344],
  "Fairfield, CA"         => [38.2568, -122.040],
  "Ventura, CA"           => [34.2681, -119.255],
  "Temecula, CA"          => [33.5019, -117.125],
  "Antioch, CA"           => [37.9775, -121.798],
  "Richmond, CA"          => [37.9530, -122.359],
  "West Covina, CA"       => [34.0559, -117.910],
  "Murrieta, CA"          => [33.5719, -117.191],
  "Norwalk, CA"           => [33.9069, -118.083],
  "Daly City, CA"         => [37.7009, -122.465],
  "Burbank, CA"           => [34.1890, -118.325],
  "Santa Maria, CA"       => [34.9332, -120.444],
  "El Cajon, CA"          => [32.8017, -116.960],
  "San Mateo, CA"         => [37.5603, -122.311],
  "Rialto, CA"            => [34.1118, -117.388],
  "Clovis, CA"            => [36.8289, -119.687]
}

all_terms = [
 "Take time to know yourself.",
 "A narrow focus brings big results.",
 "Show up fully.",
 "Don't make assumptions.",
 "Be patient and persistent.",
 "In order to get, you have to give.",
 "Luck comes from hard work.",
 "Be your best at all times.",
 "Don't try to impress everyone.",
 "Don't be afraid of being afraid.",
 "Listen to learn.",
 "Life's good, but it's not fair.",
 "No task is beneath you.",
 "You can't always get what you want.",
 "Don't make decisions when you are angry or ecstatic.",
 "Don't worry what other people think.",
 "Use adversity as an opportunity.",
 "Do what is right, not what is easy.",
 "Dreams remain dreams until you take action.",
 "Treat others the way you want to be treated.",
 "When you quit, you fail.",
 "Trust your instincts.",
 "Learn something new every day.",
 "Make what is valuable important.",
 "Believe in yourself."]

# https://github.com/scalableinternetservices/Luber/issues/107
deltatimes = [1.weeks, 2.hours, -30.minutes, -1.weeks, -1.weeks]

# > Rental.column_names
# => ["id", "owner_id", "renter_id", "renter_visible", "car_id", 
#     "status", "start_location", "start_longitude", "start_latitude", 
#     "end_location", "end_longitude", "end_latitude", 
#     "start_time", "end_time", "price", "terms", 
#     "created_at", "updated_at"]

sql = "INSERT INTO rentals (#{(Rental.column_names.map {|s| "`#{s}`"}).join(',')}) VALUES "
i = 0
User.all.each do |u|
  u.cars.each do |c|   # each car gets a bunch of rentals
    # old: c = Car.where(user_id: u.id).sample
    # p "User #{u.username} owns car id: #{c.id}"

    how_many[:rentals_per_car].times do

      c1, c2 = all_locations.keys.sample(2)
      lat1,lon1 = all_locations[c1]
      lat2,lon2 = all_locations[c2]
      dt = deltatimes[ i % deltatimes.length ]
      tstart = Time.at(Time.now + dt)
      tend = Time.at(tstart + 1.hours)
      status = i % Rental::MAX_STATUS # see rental.rb for meaning
      label = Rental.status_int_to_label(status)
      if label == 'Available' 
        renter = nil 
      else
        renter = (User.all-[u]).sample.id
      end
      price = rand(10...200)
      terms = all_terms.sample(1)[0]
      # puts terms

      d = {
        id:               (i+=1),
        owner_id:         u.id,
        renter_id:        renter,
        renter_visible:   true,
        car_id:           c.id,
        start_location:   c1,
        end_location:     c2,
        start_latitude:   lat1,
        start_longitude:  lon1,
        end_latitude:     lat1,
        end_longitude:    lon2,
        start_time:       tstart,
        end_time:         tend,
        price:            price,
        status:           status,  
        terms:            terms,
        skip_in_seed:     true,
        created_at:       DateTime.now,
        updated_at:       DateTime.now
      }

      if Rails.env.production?
        d[:renter_id]       = d[:renter_id].nil?  ? "NULL_SHITTY_HACK" : d[:renter_id]
        d[:created_at]      = d[:created_at].strftime("%FT%T")
        d[:updated_at]      = d[:updated_at].strftime("%FT%T")
        d[:start_time]      = d[:start_time].strftime("%FT%T")
        d[:end_time]        = d[:end_time].strftime("%FT%T")
        d[:renter_visible]  = d[:renter_visible]  ? "TRUE" : "FALSE"
        d[:skip_in_seed]    = d[:skip_in_seed]    ? "TRUE" : "FALSE"
        vals = '(' + (d.values_at(*Rental.column_names.map {|s| s.to_sym}).map {|s| s.inspect}).join(',') + ')'
        vals.gsub! "\"NULL_SHITTY_HACK\"", "NULL"  # Needs to be NULL, not "NULL" in SQL statement.
        sql += i==1 ? vals : ',' + vals
      else      
        d.delete(:id)
        d.delete(:created_at)
        d.delete(:updated_at)
        d.delete(:start_latitude)
        d.delete(:start_longitude)
        d.delete(:end_latitude)
        d.delete(:end_longitude)
        Rental.create!(d)
      end

    end
  end
end

if Rails.env.production?
  ActiveRecord::Base.connection.execute sql
end

p "Created #{Rental.count} rental posts"

###############################################
# TAGS
###############################################
# Note: no fancy direct-SQL-insertion needed here, 
# since doesn't scale w/ # users.

all_tags = ['no-smoking', 'sunroof', '5-seater', 'sporty', 'child-car-seat', 'SUV', 'off-road', 'moon-roof', 'smoking', 
  'tinted', 'fold-down-seats', 'curtains','cup-holders','arm-rests','bed','fridge','leather','stereo','backseat-tv','satellite-dish']
all_tags.each do |t|
    Tag.create!(name: t)
end

p "Created #{Tag.count} tags"

###############################################
# TAGGINGS
###############################################

# > Tagging.column_names
# => ["id", "car_id", "tag_id", "created_at", "updated_at"]

sql = "INSERT INTO taggings (#{(Tagging.column_names.map {|s| "`#{s}`"}).join(',')}) VALUES "
i = 0
Car.all.each do |c|
  # Each car has a couple random non-duplicate tags.
  Tag.all.sample(2).each do |t|
    d = {
      id:         (i+=1),
      car_id:     c.id,
      tag_id:     t.id,
      created_at: DateTime.now,
      updated_at: DateTime.now      
    }

    if Rails.env.production?
      d[:created_at]      = d[:created_at].strftime("%FT%T")
      d[:updated_at]      = d[:updated_at].strftime("%FT%T")
      vals = '(' + (d.values_at(*Tagging.column_names.map {|s| s.to_sym}).map {|s| s.inspect}).join(',') + ')'
      sql += i==1 ? vals : ',' + vals
    else      
      d.delete(:id)
      d.delete(:created_at)
      d.delete(:updated_at)
      Tagging.create!(d)
    end

  end
end

if Rails.env.production?
  ActiveRecord::Base.connection.execute sql
end

p "Created #{Tagging.count} taggings"





