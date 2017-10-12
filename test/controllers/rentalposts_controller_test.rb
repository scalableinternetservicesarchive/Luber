require 'test_helper'

class RentalpostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rentalpost = rentalposts(:one)
  end

  test "should get index" do
    get rentalposts_url
    assert_response :success
  end

  test "should get new" do
    get new_rentalpost_url
    assert_response :success
  end

  test "should create rentalpost" do
    assert_difference('Rentalpost.count') do
      post rentalposts_url, params: { rentalpost: { content: @rentalpost.content, user_id: @rentalpost.user_id } }
    end

    assert_redirected_to rentalpost_url(Rentalpost.last)
  end

  test "should show rentalpost" do
    get rentalpost_url(@rentalpost)
    assert_response :success
  end

  test "should get edit" do
    get edit_rentalpost_url(@rentalpost)
    assert_response :success
  end

  test "should update rentalpost" do
    patch rentalpost_url(@rentalpost), params: { rentalpost: { content: @rentalpost.content, user_id: @rentalpost.user_id } }
    assert_redirected_to rentalpost_url(@rentalpost)
  end

  test "should destroy rentalpost" do
    assert_difference('Rentalpost.count', -1) do
      delete rentalpost_url(@rentalpost)
    end

    assert_redirected_to rentalposts_url
  end
end
