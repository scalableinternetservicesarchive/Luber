require 'test_helper'

class RentalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @rental = Rental.new(
            owner_id: 1,
            renter_id: 2,
            car_id: 1,
            start_location: "la, ca",
            end_location: "sb, ca",
            start_time: "Jan 1, 2017",
            end_time: "Jan 5, 2017",
            price: "100.12",
            status: 0,
            terms: "no-smoking"
        )
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


end
