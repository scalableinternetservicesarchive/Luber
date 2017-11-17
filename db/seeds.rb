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
    logged_in_at: DateTime.now, 
    logged_out_at: DateTime.now )
end

User.create!(
  first_name: "Mister",
  last_name: "Admn",
  city: "Goleta",
  state: "CA",
  username: "admin01",
  email: "a@a.com",
  password: "foobar",
  admin: true,
  logged_in_at: DateTime.now, 
  logged_out_at: DateTime.now )

p "Created #{User.count} users"

###############################################
# CARS
###############################################

car_makes = ['TOYOTA','HOLDEN','FORD','NISSAN','BMW','MAZDA','MERCEDES-BENZ','VOLKSWAGEN','AUDI','KIA','PEUGEOT','HYUNDAI']
car_models = ['Civic','CR-V','Accord','Camry','F-150','Wrangler','Highlander','Grand Cherokee','RAV4','Pilot','Tacoma','CX-5','Outback','Challenger','Cherokee','Forester','Equinox','Explorer','Sorento','Mustang','Camaro','Crosstrek','Rogue','Sonata','Tucson','Odyssey','Compass','Silverado 1500','RX 350','Escape','4Runner','Traverse','XC90','Colorado','Santa Fe','Corolla','Edge','Ridgeline','Tahoe','Pacifica','Acadia','Fusion','Charger']
car_colors = ['red','orange','yellow','green','blue','purple','black','white','gray','silver']

# Car.destroy_all
User.all.each do |u|
  p "Making a car for user #{u.username}"
  Car.create!(
    user_id: u.id,
    make: car_makes.sample,
    model: car_models.sample,
    year: (1960..2017).to_a.sample,
    color: car_colors.sample,
    license_plate: "6ABC123" )
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
      status: "0",
      start_location: "Los Angeles",
      end_location: "San Francisco",
      start_time: "2018-10-30 20:00:00", 
      end_time: "2018-10-31 02:00:00",
      price: "999.99",
      terms: "Be nice" )
  end

  # Purchased rentals:
  2.times do
    Rental.create!(
      owner_id: u.id,
      renter_id: User.all.sample.id,
      car_id: c.id,
      status: "1",
      start_location: "Los Angeles",
      end_location: "San Francisco",
      start_time: "2018-10-30 20:00:00", 
      end_time: "2018-10-31 02:00:00",
      price: "111.11",
      terms: "Be nice" )
  end

  # Purchased rentals, about to shift status to "In Progress":
  1.times do
    Rental.create!(
      owner_id: u.id,
      renter_id: User.all.sample.id,
      car_id: c.id,
      status: "1",
      start_location: "Los Angeles",
      end_location: "San Francisco",
      start_time: DateTime.now + 2.minutes,
      end_time: DateTime.now + 4.minutes, 
      price: "123.45",
      terms: "Quick drive only" )
  end
end

p "Created #{Rental.count} rental posts"

###############################################
# TAGS
###############################################

# Tag.destroy_all
all_tags = ['no-smoking', 'sunroof', 'sporty', 'child-car-seat', 'SUV', 'off-road', 'moon-roof', 'smoking', 'tinted', 'fold-down-seats', 'curtains','cup-holders','arm-rests','bed','fridge','leather','stereo','backseat-tv','satellite-dish']
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