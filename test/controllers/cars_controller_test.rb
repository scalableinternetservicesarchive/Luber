require 'test_helper'

class CarsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = User.create!(username: "Example User", email:"user@example.com", password: "foobar", password_confirmation: "foobar")
    @car = Car.create!(user_id: @user.id, make: "Ford", model: "Mustang", year: 2000, color: "red", plate_number: "8DEF234")
  end

  test "should get new" do
    get new_car_url
    assert_response :success
  end

  test "should create car" do
    assert_difference('Car.count') do
      post cars_url, params: { car: { user_id: @car.user_id, make: @car.make, model: @car.model, year: @car.year, color: @car.color, plate_number: @car.plate_number } }
    end

    assert_redirected_to car_url(Car.last)
  end

  test "should show car" do
    get car_url(@car)
    assert_response :success
  end

  test "should get edit" do
    get edit_car_url(@car)
    assert_response :success
  end

  test "should update car" do
    patch car_url(@car), params: { car: { user_id: @car.user_id, make: @car.make, model: @car.model, year: @car.year, color: @car.color, plate_number: @car.plate_number } }
    assert_redirected_to car_url(@car)
  end

  test "should destroy car" do
    log_in_as(@user, password: "foobar")
    assert_difference('Car.count', -1) do
      delete car_url(@car)
    end

    assert_redirected_to controller: 'users', action: 'cars', id: @user.id
  end
end
