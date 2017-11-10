require 'test_helper'

class RentalPostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user1 = User.create!(name: "Michael", email:"michael@example.com",
                          password: "foobar", password_confirmation: "foobar")
    @user2 = User.create!(name: "Justin", email:"justin@example.com",
                          password: "foobar", password_confirmation: "foobar")

    @car = Car.create!(user_id: @user1.id, plate_num: "m123", model: "chev", color: "red", year: 1)

    @rental_post = RentalPost.create!(car_id: @car.id, owner_id: @user1.id, renter_id: @user2.id, start_location: "Santa Barbara", end_location: "Mountain View",
        start_time: "2017-10-17 20:20:37", end_time: "2017-10-18 20:20:37", price: 1.5)
  end

  test "should get index" do
    get rental_posts_url
    assert_template 'rental_posts/index'
  end

  test "should get new" do
    log_in_as(@user1, password: "foobar")
    get new_rental_post_url
    assert_template 'rental_posts/new'
  end

  test "should create rental_post" do
    log_in_as(@user1, password: "foobar")
    assert_difference('RentalPost.count') do
      post rental_posts_url, params: { rental_post: { car_id: @rental_post.car_id, end_location: @rental_post.end_location, end_time: @rental_post.end_time, owner_id: @rental_post.owner_id, price: @rental_post.price, renter_id: @rental_post.renter_id, start_location: @rental_post.start_location, start_time: @rental_post.start_time } }
    end

    assert_redirected_to rental_post_url(RentalPost.last)
  end

  test "should show rental_post" do
    get rental_post_url(@rental_post)
    assert_response :success
  end

  test "should get edit" do
    log_in_as(@user1, password: "foobar")
    get edit_rental_post_url(@rental_post)
    assert_response :success
  end

  test "should update rental_post" do
    log_in_as(@user1, password: "foobar")
    patch rental_post_url(@rental_post), params: { rental_post: { car_id: @rental_post.car_id, end_location: @rental_post.end_location, end_time: @rental_post.end_time, owner_id: @rental_post.owner_id, price: @rental_post.price, renter_id: @rental_post.renter_id, start_location: @rental_post.start_location, start_time: @rental_post.start_time } }
    assert_redirected_to rental_post_url(@rental_post)
  end

  test "should destroy rental_post" do
    log_in_as(@user1, password: "foobar")
    assert_difference('RentalPost.count', -1) do
      delete rental_post_url(@rental_post)
    end

    assert_redirected_to rental_posts_url
  end

  # :show, :new, :create, :edit, :update, :destroy
  test 'should redirect when not authenticated to access rental posts' do
    get new_rental_post_url
    assert_not flash.empty?
    assert_redirected_to login_url

    post rental_posts_url, params: { rental_post: { car_id: @rental_post.car_id, end_location: @rental_post.end_location, end_time: @rental_post.end_time, owner_id: @rental_post.owner_id, price: @rental_post.price, renter_id: @rental_post.renter_id, start_location: @rental_post.start_location, start_time: @rental_post.start_time } }
    assert_not flash.empty?
    assert_redirected_to login_url

    get edit_rental_post_url(@rental_post)
    assert_not flash.empty?
    assert_redirected_to login_url

    patch rental_post_url(@rental_post), params: { rental_post: { car_id: @rental_post.car_id, end_location: @rental_post.end_location, end_time: @rental_post.end_time, owner_id: @rental_post.owner_id, price: @rental_post.price, renter_id: @rental_post.renter_id, start_location: @rental_post.start_location, start_time: @rental_post.start_time } }
    assert_not flash.empty?
    assert_redirected_to login_url

    delete rental_post_url(@rental_post)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

end
