require 'test_helper'

class RentalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user1 = User.create!(username: "Michael", email:"michael@example.com", password: "foobar", password_confirmation: "foobar")
    @user2 = User.create!(username: "Justin", email:"justin@example.com", password: "foobar", password_confirmation: "foobar")

    @car = Car.create!(user_id: @user1.id, make: "Ford", model: "Mustang", year: 2000, color: "red", license_plate: "3asd123")

    @rental = Rental.create!(owner_id: @user1.id, renter_id: @user2.id, car_id: @car.id, start_location: "Santa Barbara", end_location: "Mountain View",
        start_time: "2017-10-17 20:20:37", end_time: "2017-10-18 20:20:37", price: 1.53, status: 0, terms: "My terms",
        start_latitude: 34.3987087, start_longitude:-119.8198962)
  end

  test "should get index" do
    get rentals_url
    assert_response :success
  end

  test "should get new" do
    log_in_as(@user1, password: "foobar")
    get new_rental_url
    assert_response :success
  end

  test "if user has no cars they can not create a rental post" do
    log_in_as(@user2, password: "foobar")
    get new_rental_url
    assert_redirected_to rentals_url
    assert_not flash.empty?
  end

  test "should create rental" do
    log_in_as(@user1, password: "foobar")
    assert_difference('Rental.count') do
      post rentals_url, params: { rental: { owner_id: @rental.owner_id, renter_id: @rental.renter_id, car_id: @rental.car_id, 
        start_location: @rental.start_location, end_location: @rental.end_location, start_time: @rental.start_time, end_time: @rental.end_time, 
        price: @rental.price, status: @rental.status, terms: @rental.terms, start_latitude:@rental.start_latitude, start_longitude:@rental.start_longitude } }
    end

    assert_redirected_to rental_url(Rental.last)
  end

  test "should show rental" do
    get rental_url(@rental)
    assert_response :success
  end

  test "should get edit" do
    log_in_as(@user1, password: "foobar")
    get edit_rental_url(@rental)
    assert_response :success
  end

  test "should update rental" do
    log_in_as(@user1, password: "foobar")
    patch rental_url(@rental), params: { rental: { owner_id: @rental.owner_id, renter_id: @rental.renter_id, car_id: @rental.car_id, 
        start_location: @rental.start_location, end_location: @rental.end_location, start_time: @rental.start_time, end_time: @rental.end_time, 
        price: @rental.price, status: @rental.status, terms: @rental.terms, start_latitude:@rental.start_latitude, start_longitude:@rental.start_longitude } }
    assert_redirected_to rental_url(@rental)
  end

  test "should destroy rental" do
    log_in_as(@user1, password: "foobar")
    assert_difference('Rental.count', -1) do
      delete rental_url(@rental)
    end

    assert_redirected_to controller: 'users', action: 'rentals', id: @user1.id
  end

  # :show, :new, :create, :edit, :update, :destroy
  test 'should redirect when not authenticated to access rental posts' do
    get new_rental_url
    assert_not flash.empty?
    assert_redirected_to login_url

    post rentals_url, params: { rental: { owner_id: @rental.owner_id, renter_id: @rental.renter_id, car_id: @rental.car_id,
                                          start_location: @rental.start_location, end_location: @rental.end_location, start_time: @rental.start_time, end_time: @rental.end_time,
                                          price: @rental.price, status: @rental.status, terms: @rental.terms } }
    assert_not flash.empty?
    assert_redirected_to login_url

    get edit_rental_url(@rental)
    assert_not flash.empty?
    assert_redirected_to login_url

    patch rental_url(@rental), params: { rental: { owner_id: @rental.owner_id, renter_id: @rental.renter_id, car_id: @rental.car_id,
                                                   start_location: @rental.start_location, end_location: @rental.end_location, start_time: @rental.start_time, end_time: @rental.end_time,
                                                   price: @rental.price, status: @rental.status, terms: @rental.terms } }
    assert_not flash.empty?
    assert_redirected_to login_url

    delete rental_url(@rental)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect when not owner of rentalpost EDIT' do
    log_in_as(@user2, password: "foobar")
    get edit_rental_url(@rental)
    assert_not flash.empty?
    assert_redirected_to @rental
  end

  test 'should redirect when not owner of rentalpost UPDATE' do
    log_in_as(@user2, password: "foobar")
    patch rental_url(@rental), params: { rental: { owner_id: @rental.owner_id, renter_id: @rental.renter_id, car_id: @rental.car_id,
                                                   start_location: @rental.start_location, end_location: @rental.end_location, start_time: @rental.start_time, end_time: @rental.end_time,
                                                   price: @rental.price, status: @rental.status, terms: @rental.terms } }
    assert_not flash.empty?
    assert_redirected_to @rental
  end

  test 'should redirect when not owner of rentalpost DELETE' do
    log_in_as(@user2, password: "foobar")
    delete rental_url(@rental)
    assert_not flash.empty?
    assert_redirected_to @rental
  end

end
