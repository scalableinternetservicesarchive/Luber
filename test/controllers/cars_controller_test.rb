require 'test_helper'

class CarsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = User.create!(
      username: "ExampleUser", 
      email:"user@example.com", 
      password: "password", 
      password_confirmation: "password")

    @badboi = User.create!(
      username: "BadBoi", 
      email:"bad@boi.com", 
      password: "password", 
      password_confirmation: "password")

    @car = Car.create!(
      user_id: @user.id, 
      make: "Ford", 
      model: "Mustang", 
      year: 2000, 
      color: "red", 
      license_plate: "8DEF234")
  end

  test "should get new" do
    sign_in_as(@user, password: "password")
    get new_car_url
    assert_response :success
  end

  test "should create car" do
    sign_in_as(@user, password: "password")
    assert_difference('Car.count') do
      post cars_url, params: { 
        car: { 
          user_id: @car.user_id, 
          make: @car.make, 
          model: @car.model, 
          year: @car.year, 
          color: @car.color, 
          license_plate: @car.license_plate } }
    end

    assert_redirected_to cars_user_path(@user.username)
  end

  test "should get edit" do
    sign_in_as(@user, password: "password")
    get edit_car_url(@car)
    assert_response :success
  end

  test "should update car" do
    sign_in_as(@user, password: "password")
    patch car_url(@car), params: { 
      car: { 
        user_id: @car.user_id, 
        make: @car.make, 
        model: @car.model, 
        year: @car.year, 
        color: @car.color, 
        license_plate: @car.license_plate } }
    assert_redirected_to cars_user_path(@user.username)
  end

  test "should destroy car" do
    sign_in_as(@user, password: "password")
    assert_difference('Car.count', -1) do
      delete car_url(@car)
    end

    assert_redirected_to cars_user_path(@user.username)
  end

  test "should redirect if guest tries to create a car" do
    get new_car_url
    assert_redirected_to signin_url
    assert_not flash.empty?

    post cars_url, params: { 
      car: { 
        user_id: @car.user_id, 
        make: @car.make, 
        model: @car.model, 
        year: @car.year, 
        color: @car.color, 
        license_plate: @car.license_plate } }
    assert_redirected_to signin_url
    assert_not flash.empty?
  end

  test "should redirect if guest tries to edit a car" do
    get edit_car_url(@car)
    assert_redirected_to signin_url
    assert_not flash.empty?
  end

  test "should redirect if guest tries to update car" do
    patch car_url(@car), params: { 
      car: { 
        user_id: @car.user_id, 
        make: @car.make, 
        model: @car.model, 
        year: @car.year, 
        color: @car.color, 
        license_plate: @car.license_plate } }
    assert_redirected_to signin_url
    assert_not flash.empty?
  end

  test "should redirect if guest tries to delete a car" do
    delete car_url(@car)
    assert_redirected_to signin_url
    assert_not flash.empty?
  end

  test "should redirect if non-owner tries to edit car" do
    sign_in_as(@badboi, password: "password")
    get edit_car_url(@car)
    assert_redirected_to overview_user_path(@badboi)
    assert_not flash.empty?
  end

  test "should redirect if non-owner tries to update car" do
    sign_in_as(@badboi, password: "password")
    patch car_url(@car), params: { 
      car: { 
        user_id: @car.user_id, 
        make: @car.make, 
        model: @car.model, 
        year: @car.year, 
        color: @car.color, 
        license_plate: @car.license_plate } }
    assert_redirected_to overview_user_path(@badboi)
    assert_not flash.empty?
  end

  test "should redirect if non-owner tries to delete car" do
    sign_in_as(@badboi, password: "password")
    delete car_url(@car)
    assert_redirected_to overview_user_path(@badboi)
    assert_not flash.empty?
  end

  test 'should fail to create if car data does not validate' do
    sign_in_as(@user, password: "password")
    post cars_url, params: { 
      car: { 
        user_id: @car.user_id,
        make: '',
        model: '',
        year: -24143454.2133,
        color: '34',
        license_plate: 'akslfdj;asdf a;ofsdofj ial; b;asdjf' } }

    assert_template 'cars/new'
    assert_not flash.empty?
  end

  test 'should fail to update if car data does not validate' do
    sign_in_as(@user, password: "password")
    patch car_url(@car), params: { 
      car: { 
        user_id: @car.user_id,
        make: nil,
        model: nil,
        year: nil,
        color: nil,
        license_plate: '' } }
    assert_template 'cars/edit'
    assert_not flash.empty?
  end
end
