###############################################
# REMOTE (production)

# https://swaac.tamouse.org/swaac/2013/09/03/mass-inserting-data-in-rails-without-killing-your-performance-coffeepowered/
# https://piazza.com/class/j789lo09yai5qx?cid=78

# require "ar-extensions"

# Update nov 29, 2017: If running in production, 

# 2 issues:
# 1. make EB seed upon deploy.
# 2. make this seed file do different things in production vs dev/test.

###############################################

# Warning: User_test fails (fails non-NULL constraint) 
# if you use direct sql inject
# in non-production env, even tho it should work. 

if $direct_sql_inject
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
# d1 = { first_name: "Bob", last_name: "Jones", city: "Goleta", state: "CA", username: "skater41", email: "user1@boo.com", password: "password", admin: false, signed_in_at: "2017-11-27 20:32:15" }
# d2 = { first_name: "Justin", last_name: "Jones", city: "Goleta", state: "CA", username: "skater42", email: "user2@boo.com", password: "password", admin: false, signed_in_at: "2017-11-27 20:32:35" }
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
#     d[:password_digest] = User.digest('password')
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

###############################################

cols = User.column_names
delimited_cols = cols.map {|s| $col_name_delim + "#{s}" + $col_name_delim}
sql = "INSERT INTO users (#{delimited_cols.join(',')}) VALUES "

PASSWORD = 'password'
PASSWORD_HASH = User.digest(PASSWORD)

user_ids = (1..$how_many[:user]).to_a

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

  if $direct_sql_inject
    d[:signed_in_at]    = NOW_STR
    d[:created_at]      = NOW_STR
    d[:updated_at]      = NOW_STR
    d[:admin]           = d[:admin] ? "TRUE" : "FALSE"
    d[:password_digest] = PASSWORD_HASH
    vals = dict_to_db_str(d,cols,$val_delim)
    sql += i==1 ? vals : ',' + vals
  else      
    d.delete(:id)
    d.delete(:created_at)
    d.delete(:updated_at)
    User.create!(d)
  end
  
end

if $direct_sql_inject
  ActiveRecord::Base.connection.execute sql
end

puts "Created #{User.count} users"
puts DateTime.now


###############################################
# CARS
###############################################

#> Car.column_names
#=> ["id", "user_id", "make", "model", "year", "color", "license_plate", "created_at", "updated_at"]

cols = Car.column_names
delimited_cols = cols.map {|s| $col_name_delim + "#{s}" + $col_name_delim}
sql = "INSERT INTO cars (#{delimited_cols.join(',')}) VALUES "
i = 0

users_cars_ids = {}  # uid => list_of_his_car_ids
user_ids.each do |uid|
  users_cars_ids[uid] = []
end

# User.all.each do |u|
user_ids.each do |uid|  # optimization: reduce # db queries 
  $how_many[:cars_per_user].times do 
    # puts "Making a car for user #{u.username} (total cars: #{i+1})"
    d = {
      id:             (i+=1),
      user_id:        uid, # u.id,
      make:           $all_car_makes.sample,
      model:          $all_car_models.sample,
      year:           (1960..2017).to_a.sample,
      color:          $all_car_colors.sample,
      license_plate:  [(0..9).to_a.sample, ('A'..'Z').to_a.sample(3), (0..9).to_a.sample(3)].join,
      created_at:     NOW_DT,
      updated_at:     NOW_DT
    }

    users_cars_ids[uid].push i  # remember which car this user owns

    if $direct_sql_inject
      d[:created_at]      = NOW_STR
      d[:updated_at]      = NOW_STR
      vals = dict_to_db_str(d,cols,$val_delim)
      sql += i==1 ? vals : ',' + vals
    else      
      d.delete(:id)
      d.delete(:created_at)
      d.delete(:updated_at)
      Car.create!(d)
    end
  end
end

if $direct_sql_inject
  ActiveRecord::Base.connection.execute sql
end

puts "Created #{Car.count} cars"
puts DateTime.now

# ["id", "user_id", "renter_id", "renter_visible", "car_id", "status", "start_location", "start_longitude", 
#  "start_latitude", "end_location", "end_longitude", "end_latitude", "start_time", "end_time", "price", "terms", "created_at", "updated_at"]

# https://github.com/scalableinternetservices/Luber/issues/107
deltatimes = [1.weeks, 2.hours, -30.minutes, -1.weeks, -1.weeks]
TSTARTS = deltatimes.map {|dt| Time.at(Time.now + dt)}
TENDS   = TSTARTS.map {|tstart| Time.at(tstart + 1.hours)}

# > Rental.column_names
# => ["id", "user_id", "renter_id", "renter_visible", "car_id", 
#     "status", "start_location", "start_longitude", "start_latitude", 
#     "end_location", "end_longitude", "end_latitude", 
#     "start_time", "end_time", "price", "terms", 
#     "created_at", "updated_at"]

cols = Rental.column_names
delimited_cols = cols.map {|s| $col_name_delim + "#{s}" + $col_name_delim}
sql = "INSERT INTO rentals (#{delimited_cols.join(',')}) VALUES "
i = 0

# Avoid using ORM for speed:
user_ids.each do |uid|
  users_cars_ids[uid].each do |cid|

# old:
# User.all.each do |u|
  # u.cars.each do |c|   # each car gets a bunch of rentals

    # old old: c = Car.where(user_id: u.id).sample
    # puts "User #{u.username} owns car id: #{c.id}"

    $how_many[:rentals_per_car].times do

      c1, c2 = $all_locations.keys.sample(2)
      lat1,lon1 = $all_locations[c1]
      lat2,lon2 = $all_locations[c2]
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
      terms = $all_terms.sample(1)[0]
      # puts terms

      d = {
        id:               (i+=1),
        user_id:          uid, # u.id,
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

      if $direct_sql_inject
        d[:renter_id]       = d[:renter_id].nil?  ? "NULL_SHITTY_HACK" : d[:renter_id]
        d[:created_at]      = NOW_STR
        d[:updated_at]      = NOW_STR
        d[:start_time]      = NOW_STR
        d[:end_time]        = NOW_STR
        d[:renter_visible]  = d[:renter_visible]  ? "TRUE" : "FALSE"
        d[:skip_in_seed]    = d[:skip_in_seed]    ? "TRUE" : "FALSE"
        vals = dict_to_db_str(d,cols,$val_delim)
        vals.gsub! ($val_delim + "NULL_SHITTY_HACK" + $val_delim), "NULL"  # Needs to be NULL, not "NULL" in SQL statement.
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

if $direct_sql_inject
  ActiveRecord::Base.connection.execute sql
end

puts "Created #{Rental.count} rental posts"
puts DateTime.now


###############################################
# TAGS

# Note: no fancy direct-SQL-insertion needed here, 
# since doesn't scale w/ # users.

###############################################

$all_tags.each do |t|
    Tag.create!(name: t)
end

TAG_IDS = Tag.ids

puts "Created #{Tag.count} tags"
puts DateTime.now


###############################################
# TAGGINGS
###############################################

# > Tagging.column_names
# => ["id", "car_id", "tag_id", "created_at", "updated_at"]

cols = Tagging.column_names
delimited_cols = cols.map {|s| $col_name_delim + "#{s}" + $col_name_delim}
sql = "INSERT INTO taggings (#{delimited_cols.join(',')}) VALUES "
i = 0

(1..Car.count).to_a.each do |cid|
# Car.all.each do |c|
  # Each car has a couple random non-duplicate tags.
  # Tag.all.sample(2).each do |t|
  # Faster:
  2.times do |t|
    d = {
      id:         (i+=1),
      car_id:     cid, # c.id,
      tag_id:     TAG_IDS[(cid + t) % TAG_IDS.length], # t.id,
      created_at: NOW_DT,
      updated_at: NOW_DT      
    }

    if $direct_sql_inject
      d[:created_at]      = NOW_STR
      d[:updated_at]      = NOW_STR
      vals = dict_to_db_str(d,cols,$val_delim)
      sql += i==1 ? vals : ',' + vals
    else      
      d.delete(:id)
      d.delete(:created_at)
      d.delete(:updated_at)
      Tagging.create!(d)
    end

  end
end

if $direct_sql_inject
  ActiveRecord::Base.connection.execute sql
end

puts "Created #{Tagging.count} taggings"
puts DateTime.now


# re-enable logger
if $direct_sql_inject
  ActiveRecord::Base.logger.level = 0
end

# Reset ids of each table, so Rails knows where to start 
# Otherwise User.create!(...) will fail due to duplicate id.
# Source: https://stackoverflow.com/questions/2097052/rails-way-to-reset-seed-on-id-field
if $direct_sql_inject
  ['users','cars','rentals','tags','taggings'].each do |t|
    ActiveRecord::Base.connection.reset_pk_sequence!(t)
  end
end
