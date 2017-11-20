require 'test_helper'

class CarTest < ActiveSupport::TestCase

  def setup
    u = User.create!(username: "Example User", email:"user@example.com",password: "foobar", password_confirmation: "foobar")
    @car = Car.create!(user_id: u.id, make: "Honda", model: "Civic", year: 2011, color: "blue", license_plate: "3asd234")
    puts "New car valid?: #{@car.valid?}"
  end

  test "license plate len 2 ok" do
    @car.license_plate = "12"
    assert @car.valid?
  end

  test "license plate len 7 ok" do
    @car.license_plate = "1234567"
    assert @car.valid?
  end

  test "license plate len 8 not ok" do
    @car.license_plate = "12345678"
    assert @car.invalid?
  end

  test "license plate len 1 not ok" do
    @car.license_plate = "1"
    assert @car.invalid?
  end

  test "license plate has illegal char" do
    @car.license_plate = "6we!123"
    assert @car.invalid?
  end

  test "license plate has only let, num, spaces" do
    @car.license_plate = "6wer123"
    assert @car.valid?
  end

  test "license plate has at least 2 non-sp characters" do
    @car.license_plate = "1     2"
    assert @car.valid?
  end

  test "year should be after 1900" do
    @car.year = 1899
    assert_not @car.valid?
  end

end
