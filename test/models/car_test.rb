require 'test_helper'

class CarTest < ActiveSupport::TestCase

  def setup
    u = User.create!(username: "Example User", email:"user@example.com",password: "foobar", password_confirmation: "foobar")
    @car = Car.create!(user_id: u.id, make: "Honda", model: "Civic", year: 2011, color: "blue", license_plate: "3asd234")
    puts "New car valid?: #{@car.valid?}"
  end


  test "license plate has form DLLLDDD, all digs not allowed" do
    @car.license_plate = "1234567"
    assert_not @car.valid?
  end

  test "license plate has form DLLLDDD" do
    @car.license_plate = "6wer123"
    puts "Plate: #{@car.license_plate}, valid?: #{@car.valid?}"
    assert @car.valid?
  end

  test "year should be after 1900" do
    @car.year = 1899
    assert_not @car.valid?
  end

end
