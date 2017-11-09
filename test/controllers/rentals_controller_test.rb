require 'test_helper'

class RentalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user1 = User.create!(name: "Michael", email:"michael@example.com",
                          password: "foobar", password_confirmation: "foobar")
    @user2 = User.create!(name: "Justin", email:"justin@example.com",
                          password: "foobar", password_confirmation: "foobar")

    @car = Car.create!(user_id: @user1.id, plate_num: "m123", model: "chev", color: "red", year: 1)

    @rental = Rental.create!(car_id: @car.id, owner_id: @user1.id, renter_id: @user2.id, start_location: "Santa Barbara", end_location: "Mountain View",
        start_time: "2017-10-17 20:20:37", end_time: "2017-10-18 20:20:37", price: 1.5)
  end

  test "should get index" do
    get rentals_url
    assert_response :success
  end

  test "should get new" do
    get new_rental_url
    assert_response :success
  end

  test "should create rental" do
    assert_difference('Rental.count') do
      post rentals_url, params: { rental: { car_id: @rental.car_id, end_location: @rental.end_location, end_time: @rental.end_time, owner_id: @rental.owner_id, price: @rental.price, renter_id: @rental.renter_id, start_location: @rental.start_location, start_time: @rental.start_time } }
    end

    assert_redirected_to rental_url(Rental.last)
  end

  test "should show rental" do
    get rental_url(@rental)
    assert_response :success
  end

  test "should get edit" do
    get edit_rental_url(@rental)
    assert_response :success
  end

  test "should update rental" do
    patch rental_url(@rental), params: { rental: { car_id: @rental.car_id, end_location: @rental.end_location, end_time: @rental.end_time, owner_id: @rental.owner_id, price: @rental.price, renter_id: @rental.renter_id, start_location: @rental.start_location, start_time: @rental.start_time } }
    assert_redirected_to rental_url(@rental)
  end

  test "should destroy rental" do
    assert_difference('Rental.count', -1) do
      delete rental_url(@rental)
    end

    assert_redirected_to rentals_url
  end

end
