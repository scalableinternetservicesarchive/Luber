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
    how_many = {user: 10, cars_per_user: 2, rentals_per_car: 5}
    col_name_delim = "`" # sqlite3
    val_delim = '"'  # sqlite3
    direct_sql_inject = false

  when 'production'
    puts 'in production!'
    how_many = {user: 100, cars_per_user: 2, rentals_per_car: 5}
    col_name_delim = "" # postgres
    val_delim = "'"  # postgres
    direct_sql_inject = true
end

# Warning: Some weird error if you use direct sql inject
# in non-production env, even tho it should work.


if direct_sql_inject
  # turn off logger (we turn it back @ end of file)
  # (This prevents rails db:seed from spewing)
  ActiveRecord::Base.logger.level = 1 
end

def dict_to_db_str(d,cols,delim)

  # Usage:
  #
  # > di = {name: "Justin", age: 34, ssn: "\"Um no,\" he said"}
  #   => {:name=>"Justin", :age=>34, :ssn=>"\"Um no,\" he said"}
  # > cols = ["name","age","ssn","nope"]
  # > puts dict_to_db_str(di,cols,"'")
  #   ('Justin', 34, '\'Um no,\' he said', nil)

  # puts cols
  # puts d.keys.first.class
  # puts cols.first.class

  if d.keys.first.is_a? Symbol and cols.first.is_a? String
    # puts "need syms"
    cols.map! {|s| s.to_sym}
  elsif d.keys.first.is_a? String and cols.first.is_a? Symbol
    # puts "need strs"
    cols.map! {|s| s.to_s}
  end
  # puts cols

  vs = d.values_at(*cols)
  # puts vs
  s = vs.inspect
  # puts s
  s[0] = '('
  s[-1] = ')'
  s.gsub! '"', delim

  return s
end

NOW_DT = DateTime.now
NOW_STR = NOW_DT.strftime("%FT%T")

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
# NOTE: Doesn't work in production (Postgres has different syntax), 
# see other example below
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


# Postgres example
# (Copy/paste to rails c on AWS, which uses Postgres)
# (That is, from luber@ec2.cs291.com, do this:)
# $ eb ssh -e 'ssh -i ~/luber.pem'
# $ cd /var/app/current
# $ rails c
#
# irb> sql = <<EOF
# irb> INSERT INTO users (id,first_name,last_name,city,state,username,email,password_digest,admin,signed_in_at,created_at,updated_at) VALUES (13,'Bob13','Jones','Goleta','CA','skater413','user13@boo.com','$2a$10$riUtUdM5F5dBaqqi81AIJ.AvJuTscIK/omdLEkmRX1AwhfXnXRmny','FALSE','2017-11-30T17:35:57','2017-11-30T17:35:57','2017-11-30T17:35:57'),(14,'Bob14','Jones','Goleta','CA','skater414','user14@boo.com','$2a$10$riUtUdM5F5dBaqqi81AIJ.AvJuTscIK/omdLEkmRX1AwhfXnXRmny','FALSE','2017-11-30T17:35:57','2017-11-30T17:35:57','2017-11-30T17:35:57') 
# irb> EOF
# irb> sql = sql.strip
# irb> ActiveRecord::Base.connection.execute sql

cols = User.column_names
delimited_cols = cols.map {|s| col_name_delim + "#{s}" + col_name_delim}
sql = "INSERT INTO users (#{delimited_cols.join(',')}) VALUES "

PASSWORD = 'foobar'
PASSWORD_HASH = User.digest(PASSWORD)

user_ids = (1..how_many[:user]).to_a

user_ids.each do |i|  # don't use .times, then id will be 0, bad.

  d = { 
      id:           i,
      first_name:   "Bob",
      last_name:    "Jones",
      city:         "Goleta",
      state:        "CA",
      username:     "skater4#{i}",
      email:        "user#{i}@boo.com",
      password:     PASSWORD,
      admin:        false,
      signed_in_at: NOW_DT,
      created_at:   NOW_DT,
      updated_at:   NOW_DT
      }

  if i==1  # Make admin
    d.merge!  first_name:   "Mister",
              last_name:    "Admn",
              username:     "admin01",
              email:        "a@a.com",
              admin:        true
  end

  if direct_sql_inject
    d[:signed_in_at]    = NOW_STR
    d[:created_at]      = NOW_STR
    d[:updated_at]      = NOW_STR
    d[:admin]           = d[:admin] ? "TRUE" : "FALSE"
    d[:password_digest] = PASSWORD_HASH
    vals = dict_to_db_str(d,cols,val_delim)
    sql += i==1 ? vals : ',' + vals
  else      
    d.delete(:id)
    d.delete(:created_at)
    d.delete(:updated_at)
    User.create!(d)
  end
  
end

if direct_sql_inject
  ActiveRecord::Base.connection.execute sql
end

p "Created #{User.count} users"
p DateTime.now


###############################################
# CARS
###############################################


#> Car.column_names
#=> ["id", "user_id", "make", "model", "year", "color", "license_plate", "created_at", "updated_at"]

car_makes = ['Toyota','Ford','Nissan','BMW','Mazda','Mercedes','Volkswagen','Audi','Kia','Hyundai','Subaru']
car_models = ['Civic','Accord','Camry','F-150','Wrangler','Highlander','Grand Cherokee','Tacoma','Outback','Forester',
  'Equinox','Explorer','Mustang','Camaro','Tacoma','Odyssey','Silverado','Escape','Corolla','Tahoe','Fusion','Charger']
car_colors = ['Red','Orange','Yellow','Green','Blue','Purple','Black','White','Gray','Silver']


cols = Car.column_names
delimited_cols = cols.map {|s| col_name_delim + "#{s}" + col_name_delim}
sql = "INSERT INTO cars (#{delimited_cols.join(',')}) VALUES "
i = 0

users_cars_ids = {}  # uid => list_of_his_car_ids
user_ids.each do |uid|
  users_cars_ids[uid] = []
end

# User.all.each do |u|
user_ids.each do |uid|  # optimization: reduce # db queries 
  how_many[:cars_per_user].times do 
    # p "Making a car for user #{u.username} (total cars: #{i+1})"
    d = {
      id:             (i+=1),
      user_id:        uid, # u.id,
      make:           car_makes.sample,
      model:          car_models.sample,
      year:           (1960..2017).to_a.sample,
      color:          car_colors.sample,
      license_plate:  [(0..9).to_a.sample, ('A'..'Z').to_a.sample(3), (0..9).to_a.sample(3)].join,
      created_at:     NOW_DT,
      updated_at:     NOW_DT
    }

    users_cars_ids[uid].push i  # remember which car this user owns

    if direct_sql_inject
      d[:created_at]      = NOW_STR
      d[:updated_at]      = NOW_STR
      vals = dict_to_db_str(d,cols,val_delim)
      sql += i==1 ? vals : ',' + vals
    else      
      d.delete(:id)
      d.delete(:created_at)
      d.delete(:updated_at)
      Car.create!(d)
    end
  end
end

if direct_sql_inject
  ActiveRecord::Base.connection.execute sql
end

p "Created #{Car.count} cars"
p DateTime.now

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
 "Dont make assumptions.",
 "Be patient and persistent.",
 "In order to get, you have to give.",
 "Luck comes from hard work.",
 "Be your best at all times.",
 "Dont try to impress everyone.",
 "Dont be afraid of being afraid.",
 "Listen to learn.",
 "Lifes good, but its not fair.",
 "No task is beneath you.",
 "You cant always get what you want.",
 "Dont make decisions when you are angry or ecstatic.",
 "Dont worry what other people think.",
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
TSTARTS = deltatimes.map {|dt| Time.at(Time.now + dt)}
TENDS   = TSTARTS.map {|tstart| Time.at(tstart + 1.hours)}

# > Rental.column_names
# => ["id", "owner_id", "renter_id", "renter_visible", "car_id", 
#     "status", "start_location", "start_longitude", "start_latitude", 
#     "end_location", "end_longitude", "end_latitude", 
#     "start_time", "end_time", "price", "terms", 
#     "created_at", "updated_at"]

cols = Rental.column_names
delimited_cols = cols.map {|s| col_name_delim + "#{s}" + col_name_delim}
sql = "INSERT INTO rentals (#{delimited_cols.join(',')}) VALUES "
i = 0

# Avoid using ORM for speed:
user_ids.each do |uid|
  users_cars_ids[uid].each do |cid|

# old:
# User.all.each do |u|
  # u.cars.each do |c|   # each car gets a bunch of rentals

    # old old: c = Car.where(user_id: u.id).sample
    # p "User #{u.username} owns car id: #{c.id}"

    how_many[:rentals_per_car].times do

      c1, c2 = all_locations.keys.sample(2)
      lat1,lon1 = all_locations[c1]
      lat2,lon2 = all_locations[c2]
      # dt = deltatimes[ i % deltatimes.length ]
      # tstart = Time.at(Time.now + dt)
      # tend = Time.at(tstart + 1.hours)
      tstart = TSTARTS[i % deltatimes.length]
      tend = TENDS[i % deltatimes.length]
      status = i % Rental::MAX_STATUS # see rental.rb for meaning
      label = Rental.status_int_to_label(status)
      if label == 'Available' 
        renter = nil 
      else
        # renter = (User.all-[u]).sample.id
        renter = (user_ids-[uid]).sample
      end
      price = rand(10..200)
      terms = all_terms.sample(1)[0]
      # puts terms

      d = {
        id:               (i+=1),
        owner_id:         uid, # u.id,
        renter_id:        renter,
        renter_visible:   true,
        car_id:           cid, # c.id,
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
        created_at:       NOW_DT,
        updated_at:       NOW_DT
      }

      if direct_sql_inject
        d[:renter_id]       = d[:renter_id].nil?  ? "NULL_SHITTY_HACK" : d[:renter_id]
        d[:created_at]      = NOW_STR
        d[:updated_at]      = NOW_STR
        d[:start_time]      = NOW_STR
        d[:end_time]        = NOW_STR
        d[:renter_visible]  = d[:renter_visible]  ? "TRUE" : "FALSE"
        d[:skip_in_seed]    = d[:skip_in_seed]    ? "TRUE" : "FALSE"
        vals = dict_to_db_str(d,cols,val_delim)
        vals.gsub! (val_delim + "NULL_SHITTY_HACK" + val_delim), "NULL"  # Needs to be NULL, not "NULL" in SQL statement.
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

if direct_sql_inject
  ActiveRecord::Base.connection.execute sql
end

p "Created #{Rental.count} rental posts"
p DateTime.now

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

NUM_TAGS = Tag.count

p "Created #{Tag.count} tags"
p DateTime.now

###############################################
# TAGGINGS
###############################################

# > Tagging.column_names
# => ["id", "car_id", "tag_id", "created_at", "updated_at"]

cols = Tagging.column_names
delimited_cols = cols.map {|s| col_name_delim + "#{s}" + col_name_delim}
sql = "INSERT INTO taggings (#{delimited_cols.join(',')}) VALUES "
i = 0

(1..Car.count).each do |cid|
# Car.all.each do |c|
  # Each car has a couple random non-duplicate tags.
  # Tag.all.sample(2).each do |t|
  # Faster:
  2.times do |t|
    d = {
      id:         (i+=1),
      car_id:     cid, # c.id,
      tag_id:     ((cid + t) % NUM_TAGS)+1, # t.id,
      created_at: NOW_DT,
      updated_at: NOW_DT      
    }

    if direct_sql_inject
      d[:created_at]      = NOW_STR
      d[:updated_at]      = NOW_STR
      vals = dict_to_db_str(d,cols,val_delim)
      sql += i==1 ? vals : ',' + vals
    else      
      d.delete(:id)
      d.delete(:created_at)
      d.delete(:updated_at)
      Tagging.create!(d)
    end

  end
end

if direct_sql_inject
  ActiveRecord::Base.connection.execute sql
end

p "Created #{Tagging.count} taggings"
p DateTime.now


# re-enable logger
if direct_sql_inject
  ActiveRecord::Base.logger.level = 0
end


