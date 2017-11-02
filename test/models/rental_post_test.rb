require 'test_helper'

class RentalPostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
      @user1 = User.create!(name: "Michael", email:"michael@example.com", password: "foobar", password_confirmation: "foobar")
      @user2 = User.create!(name: "Justin", email:"justin@example.com", password: "foobar", password_confirmation: "foobar")
      @car = Car.create!(user_id: @user1.id, plate_num: "m123", model: "chev", color: "red", year: 1)
      @rentalpost = RentalPost.new(car_id: @car.id, owner_id: @user1.id, renter_id: @user2.id, start_location: "Santa Barbara", end_location: "Sunnyvale",
          start_time: "2017-10-17 20:20:37", end_time: "2017-10-18 20:20:37", price: 1.5)
  end

  test "should be valid" do
      assert @rentalpost.valid?
  end

  test "owner id should be present" do
      @rentalpost.owner_id = nil
      assert_not @rentalpost.valid?
  end
end
