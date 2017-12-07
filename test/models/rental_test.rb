require 'test_helper'

class RentalTest < ActiveSupport::TestCase
  setup do
    @user1 = User.create!(
      username: "Michael", 
      email:"michael@example.com", 
      password: "password", 
      password_confirmation: "password", 
      signed_in_at: DateTime.current )
    
    @user2 = User.create!(
      username: "Justin", 
      email:"justin@example.com", 
      password: "password", 
      password_confirmation: "password",
      signed_in_at: DateTime.current )

    @car = Car.create!(
      user_id: @user1.id, 
      make: "Ford", 
      model: "Mustang", 
      year: 2000, 
      color: "red", 
      license_plate: "3asd123" )

    @rental = Rental.create!(
      user_id: @user1.id, 
      renter_id: @user2.id, 
      car_id: @car.id, 
      start_location: "Santa Barbara", 
      end_location: "Mountain View",
      start_time: "2018-10-17 20:20:37", 
      end_time: "2018-10-18 20:20:37", 
      price: 1.53, 
      status: 1, 
      terms: "My terms" )
  end

  test "integer price ok" do
    @rental.price = "100"
    assert @rental.valid?
  end

  test "integer price with .00 ok" do
    @rental.price = "100.00"
    assert @rental.valid?
  end

  test "price with too many decimals" do
    @rental.price = "100.123"
    assert_not @rental.valid?
  end

  test "less than 1 dollar price ok" do
    @rental.price = "0.10"
    assert @rental.valid?
  end

  test "end date before start date not ok" do
    t = DateTime.current
    @rental.start_time = t
    @rental.end_time = t-1
    assert @rental.invalid?
  end

  test "start date before end date ok" do
    t = DateTime.current + 1.hours
    @rental.start_time = t
    @rental.end_time = t+1
    assert @rental.valid?
  end

end
