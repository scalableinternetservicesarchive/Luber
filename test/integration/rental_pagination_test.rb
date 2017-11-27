require 'test_helper'

class RentalPaginationTest < ActionDispatch::IntegrationTest


  setup do
    @user = User.create!(username: "Example User", email:"user@example.com", password: "foobar", password_confirmation: "foobar")
    @user2 = User.create!(username: "Example User2", email:"user2@example.com", password: "foobar", password_confirmation: "foobar")
    @car = Car.create!(user_id: @user.id, make: "Ford", model: "Mustang", year: 2000, color: "red", license_plate: "8DEF234")

    puts "num users: #{User.count}"

    # Need to make a bunch of rentals that will be 
    @tmp_rentals = []
    50.times do |i|
        @tmp_rentals.push(
            Rental.create!(
              owner_id: @user2.id,
              renter_id: nil,
              car_id: @car.id,
              start_location: "sb, ca",
              end_location: "la, ca",
              start_time: "1:23 Nov 27, 2017",
              end_time: "1:53 Nov 27, 2017",
              price: 100,
              status: 0,   # 0 = available I'm assuming
              terms: "pass this integration test plz k thx"
              )
            )
    end
  end

  teardown do
    @user.delete
    @tmp_rentals.each {|e| e.delete}
  end




  test "Rental pagination appears" do
    puts "# users: #{User.count}, # cars: #{Car.count}, # rentals: #{Rental.count}"
    log_in_as(@user, password: "foobar")
    # get login_path
    # post login_path, params: { session: { email: @user.email, password: 'foobar'}}
    # assert is_logged_in?
    # assert_redirected_to overview_user_path(@user)
    # follow_redirect!
    # # follow_redirect! # jpp: causes an error. how to debug?
    # assert_template 'users/overview'
    # assert_select "a[href=?]", login_path, count: 0
    # assert_select "a[href=?]", logout_path
    # assert_select "a[href=?]", user_path(@user)

    get rentals_url
    assert_response :success
    assert_template 'rentals/index' 
    assert_select 'div.card', count: 8 # danger: should match how many we paginate per page...
    assert_select 'ul.pagination'
  end

end
