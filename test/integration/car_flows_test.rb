require 'test_helper'

class CarFlowsTest < ActionDispatch::IntegrationTest
  def setup
    User.create!(username: 'RickSanchez', email: 'rick@sanchez.com', password: 'foobar', password_confirmation: 'foobar')
    @user = User.where(username: 'RickSanchez').take
    @car = Car.create!(user_id: @user.id, make: 'Ford', model: 'Mustang', year: 2000, color: 'red', license_plate: '8DEF234')
  end

  teardown do
    @user.delete
  end

  test 'create, modify, and delete a car successfully' do
    log_in_as(@user, password: 'foobar')
    get new_car_url
    assert_template 'cars/new'

    # create a car
    assert_difference 'Car.count', 1 do
      post cars_url, params: { 
        car: { 
          user_id: @user.id,
          make: 'ford',
          model: 'aspire',
          year: '1992',
          color: 'white',
          license_plate: '1abc234',
          all_tags: 'sporty, cool' } }
    end
    follow_redirect!
    assert_template 'users/cars'
    assert_not flash.blank?
    assert_select 'p', 'Ford'
    assert_select 'p', 'Aspire'
    assert_select 'p', '1992'
    assert_select 'p', 'White'
    assert_select 'p', 'License Plate: 1ABC234'
    assert_select 'span', 'sporty'
    assert_select 'span', 'cool'
    mycar = Car.last
    assert_select 'a[href=?]', edit_car_path(mycar)

    # edit the car
    assert_no_difference 'Car.count' do
      patch car_url(Car.last), params: { 
        car: { 
          user_id: @user.id,
          make: 'toyota',
          model: 'prius',
          year: '2004',
          color: 'white',
          license_plate: '3bne098',
          all_tags: 'sporty' } }
    end
    follow_redirect!
    assert_template 'users/cars'
    assert_not flash.blank?
    assert_select 'a[href=?][data-method=delete]', car_path(mycar)
    mycar.reload
    assert_equal 'Toyota', mycar.make
    assert_equal 'Prius', mycar.model
    assert_equal 2004, mycar.year
    assert_equal 'White', mycar.color
    assert_equal '3BNE098', mycar.license_plate
    assert_select 'p', 'Toyota'
    assert_select 'p', 'Prius'
    assert_select 'p', '2004'
    assert_select 'p', 'White'
    assert_select 'p', 'License Plate: 3BNE098'
    assert_select 'span', 'sporty'
    assert_select 'span', count: 0, text: 'no'
    # delete the car
    assert_difference 'Car.count', -1 do
      delete car_url(@car)
    end
    follow_redirect!
    assert_template 'users/cars'
  end
end
