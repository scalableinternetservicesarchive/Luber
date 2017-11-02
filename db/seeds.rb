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

# User.destroy_all
(1..10).to_a.each do |i|
  User.create!(
    name: "User#{i}",
    email: "user#{i}@boo.com",
    # password_digest: "#{User.digest('foobarbaz')}", # no.
    password: "foobar", # yes.
    ssn: "1234",
    admin: false )
end

User.create!(
  name: "admin",
  email: "a@a.com",
  # password_digest: "#{User.digest('foobarbaz')}", # no.
  password: "foobar", # yes.
  ssn: "1234",
  admin: true )

p "Created #{User.count} users"


# Car.destroy_all
User.all.each do |u|
  p "Making a car for user #{u.name}"
  Car.create!(
    user_id:   u.id     ,      
    plate_num: "#{6}#{u.name}789" ,          
    model:     "civic"    ,  
    color:     "blue"     ,  
    year:      "2011"     )
end
p "Created #{Car.count} cars"





# RentalPost.destroy_all
User.all.each do |u|

  c = Car.where(user_id: u.id).take
  p "User #{u.name} owns car id: #{c.id}"

  # Available rentals:
  2.times do 
    RentalPost.create!(
      car_id:             c.id,
      owner_id:           u.id,
      renter_id:          nil,
      start_location:     "goleta",
      end_location:       "sb",
      start_time:         "2017-10-31 20:00:00", 
      end_time:           "2017-10-31 21:00:00",
      price:              "999"
      )
  end


  # Completed rentals:
  2.times do 
    RentalPost.create!(
      car_id:             c.id,
      owner_id:           u.id,
      renter_id:          User.all.sample.id,
      start_location:     "goleta",
      end_location:       "sb",
      start_time:         "2017-10-31 20:00:00", 
      end_time:           "2017-10-31 21:00:00",
      price:              "123"
      )
  end


end
p "Created #{RentalPost.count} rental posts"


# Tag.destroy_all
all_tags = ['no-smoking', 'sunroof', 'sporty', 'child-car-seat', 'SUV', 'off-road']
all_tags.each do |t|
    Tag.create!(name: t)
end
p "Created #{Tag.count} tags"


# Tagging.destroy_all
Car.all.each do |c|
  # Each car has a couple random tags.
  2.times do
  Tagging.create!(
      car_id: c.id,
      tag_id: Tag.all.sample.id
      )
  end
end
p "Created #{Tagging.count} taggings"
