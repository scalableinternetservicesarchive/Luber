require 'test_helper'

class RentalPostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rental_post = rental_posts(:one)
  end

  test "should get index" do
    get rental_posts_url
    assert_response :success
  end

  test "should get new" do
    get new_rental_post_url
    assert_response :success
  end

  test "should create rental_post" do
    assert_difference('RentalPost.count') do
      post rental_posts_url, params: { rental_post: { car: @rental_post.car, cost: @rental_post.cost, end_loc: @rental_post.end_loc, end_time: @rental_post.end_time, owner: @rental_post.owner, renter: @rental_post.renter, start_loc: @rental_post.start_loc, start_time: @rental_post.start_time } }
    end

    assert_redirected_to rental_post_url(RentalPost.last)
  end

  test "should show rental_post" do
    get rental_post_url(@rental_post)
    assert_response :success
  end

  test "should get edit" do
    get edit_rental_post_url(@rental_post)
    assert_response :success
  end

  test "should update rental_post" do
    patch rental_post_url(@rental_post), params: { rental_post: { car: @rental_post.car, cost: @rental_post.cost, end_loc: @rental_post.end_loc, end_time: @rental_post.end_time, owner: @rental_post.owner, renter: @rental_post.renter, start_loc: @rental_post.start_loc, start_time: @rental_post.start_time } }
    assert_redirected_to rental_post_url(@rental_post)
  end

  test "should destroy rental_post" do
    assert_difference('RentalPost.count', -1) do
      delete rental_post_url(@rental_post)
    end

    assert_redirected_to rental_posts_url
  end
end
