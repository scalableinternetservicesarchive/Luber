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

###############################################
# USERS
###############################################

# User.destroy_all
(1..10).to_a.each do |i|
  User.create!(
    first_name: "Bob#{i}",
    last_name: "Jones",
    city: "Goleta",
    state: "CA",
    username: "skater4#{i}",
    email: "user#{i}@boo.com",
    password: "foobar",
    admin: false,
    logged_in_at: "2017-11-01 20:00:00", 
    logged_out_at: "2017-11-01 20:00:00" )
end
User.create!(
  first_name: "Mister",
  last_name: "Admn",
  city: "Goleta",
  state: "CA",
  username: "WaTcher53",
  email: "a@a.com",
  password: "foobar",
  admin: true )
p "Created #{User.count} users"


###############################################
# CARS
###############################################

# Car.destroy_all
User.all.each do |u|
  p "Making a car for user #{u.username}"
  Car.create!(
    user_id: u.id,
    make: "Ford",
    model: "Bronco",
    year: "1981",
    color: "Blue",
    plate_number: "#{u.username}ZZ" )
end
p "Created #{Car.count} cars"

###############################################
# Rentals
###############################################

# Rental.destroy_all
User.all.each do |u|
  c = Car.where(user_id: u.id).take
  p "User #{u.username} owns car id: #{c.id}"

  # This user posted a few rentals, some of which have been purchased:

  # Available rentals:
  2.times do
    Rental.create!(
      owner_id: u.id,
      renter_id: nil,
      car_id: c.id,
      start_location: "Los Angeles",
      end_location: "San Francisco",
      start_time: "2018-10-30 20:00:00", 
      end_time: "2018-10-31 02:00:00",
      price: "200.43",
      status: "1",  # how to ints map to what the statuses mean?
      terms: "Be nice" )
  end

  # Purchased rentals:
  2.times do
    Rental.create!(
      owner_id: u.id,
      renter_id: User.all.sample.id,
      car_id: c.id,
      start_location: "Los Angeles",
      end_location: "San Francisco",
      start_time: "2018-10-30 20:00:00", 
      end_time: "2018-10-31 02:00:00",
      price: "200.43",
      status: "0",
      terms: "Be nice" )
  end
end
p "Created #{Rental.count} rental posts"


###############################################
# TAGS
###############################################

# Tag.destroy_all
all_tags = ['no-smoking', 'sunroof', 'sporty', 'child-car-seat', 'SUV', 'off-road', 'red','white','black','atomic-blue']
all_tags.each do |t|
    Tag.create!(name: t)
end
p "Created #{Tag.count} tags"

###############################################
# TAGGINGS
###############################################

# Tagging.destroy_all
Car.all.each do |c|
  # Each car has a couple random non-duplicate tags.
  Tag.all.sample(2).each do |t|
    Tagging.create!( car_id: c.id, tag_id: t.id )
  end
end
p "Created #{Tagging.count} taggings"

