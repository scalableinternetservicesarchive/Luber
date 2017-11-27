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
    logged_in_at: DateTime.now )
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
  logged_in_at: DateTime.now )

p "Created #{User.count} users"

###############################################
# CARS
###############################################

car_makes = ['Toyota','Ford','Nissan','BMW','Mazda','Mercedes','Volkswagen','Audi','Kia','Hyundai','Subaru']
car_models = ['Civic','Accord','Camry','F-150','Wrangler','Highlander','Grand Cherokee','Tacoma','Outback','Forester','Equinox','Explorer','Mustang','Camaro','Tacoma','Odyssey','Silverado','Escape','Corolla','Tahoe','Fusion','Charger']
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
    license_plate: [(0...9).to_a.sample, ('A'...'Z').to_a.sample(3), (0...9).to_a.sample(3)].join )
end

p "Created #{Car.count} cars"

###############################################
# Rentals
###############################################

all_cities = ["Los Angeles, CA", "San Diego, CA", "San Jose, CA", "San Francisco, CA", "Fresno, CA", "Sacramento, CA", "Long Beach, CA", "Oakland, CA", "Bakersfield, CA", "Anaheim, CA", "Santa Ana, CA", "Riverside, CA", "Stockton, CA", "Chula Vista, CA", "Irvine, CA", "Fremont, CA", "San Bernardino, CA", "Modesto, CA", "Oxnard, CA", "Fontana, CA", "Moreno Valley, CA", "Huntington Beach, CA", "Glendale, CA", "Santa Clarita, CA", "Garden Grove, CA", "Oceanside, CA", "Rancho Cucamonga, CA", "Santa Rosa, CA", "Ontario, CA", "Elk Grove, CA", "Corona, CA", "Lancaster, CA", "Palmdale, CA", "Salinas, CA", "Hayward, CA", "Pomona, CA", "Escondido, CA", "Sunnyvale, CA", "Torrance, CA", "Pasadena, CA", "Orange, CA", "Fullerton, CA", "Thousand Oaks, CA", "Visalia, CA", "Roseville, CA", "Concord, CA", "Simi Valley, CA", "East Los Angeles, CA", "Santa Clara, CA", "Victorville, CA", "Vallejo, CA", "Berkeley, CA", "El Monte, CA", "Downey, CA", "Costa Mesa, CA", "Carlsbad, CA", "Inglewood, CA", "Fairfield, CA", "San Buenaventura (Ventura), CA", "Temecula, CA", "Antioch, CA", "Richmond, CA", "West Covina, CA", "Murrieta, CA", "Norwalk, CA", "Daly City, CA", "Burbank, CA", "Santa Maria, CA", "El Cajon, CA", "San Mateo, CA", "Rialto, CA", "Clovis, CA"];
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

# Rental.destroy_all
User.all.each do |u|
  c = Car.where(user_id: u.id).sample

  # p "User #{u.username} owns car id: #{c.id}"

  # https://github.com/scalableinternetservices/Luber/issues/107
  # Generate 1 post with a start and end date sampling in the future, no renter, and status as available
  # Generate 1 post with a start and end date sampling in the (near) future and status as upcoming
  # Generate 1 post with a start date in the past and end date in the (near) future and status as In Progress
  # Generate 1 post with a start and end date sampling in the past and status canceled
  # Generate 1 post with a start and end date sampling in the past and status completed

  deltatimes = [1.weeks, 2.hours, -30.minutes, -1.weeks, -1.weeks]

  deltatimes.each_with_index do |dt,i|

    c1,c2 = all_cities.sample(2)
    tstart = Time.at(Time.now + dt)
    tend = Time.at(tstart + 1.hours)
    status = i # see rental.rb for meaning
    label = Rental.status_int_to_label(status)
    if label == 'Available' 
      renter = nil  
    else
      renter = (User.all-[u]).sample.id
    end
    price = rand(10...200)
    terms = all_terms.sample(2).join(' ')

    Rental.create!(
      owner_id: u.id,
      renter_id: renter,
      car_id: c.id,
      start_location: c1,
      end_location: c2,
      start_time: tstart,
      end_time: tend,
      price: price,
      status: status,  
      terms: terms)
  end

end

p "Created #{Rental.count} rental posts"

###############################################
# TAGS
###############################################

# Tag.destroy_all
all_tags = ['no-smoking', 'sunroof', '5-seater', 'sporty', 'child-car-seat', 'SUV', 'off-road', 'moon-roof', 'smoking', 'tinted', 'fold-down-seats', 'curtains','cup-holders','arm-rests','bed','fridge','leather','stereo','backseat-tv','satellite-dish']
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