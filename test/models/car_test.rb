require 'test_helper'

class CarTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end


  def setup
    @car = Car.new(
            user_id: 1,
            make: "Honda",
            model: "Civic",
            year: 2011,
            color: "atomic blue",
            plate_number: "2abc789"
        )
  end


  test "license plate has form DLLLDDD, all digs not allowed" do
    @car.plate_number = "1234567"
    assert_not @car.valid?
  end

  test "license plate has form DLLLDDD" do
    @car.plate_number = "6wer123"
    assert @car.valid?
  end

  test "year should be after 1900" do
    @car.year = 1899
    assert_not @car.valid?
  end

end
