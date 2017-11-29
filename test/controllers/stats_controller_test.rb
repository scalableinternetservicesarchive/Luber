require 'test_helper'

class StatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stat = stats(:one)
  end

  test "should get index" do
    get stats_url
    assert_response :success
  end

  test "should get new" do
    get new_stat_url
    assert_response :success
  end

  test "should create stat" do
    assert_difference('Stat.count') do
      post stats_url, params: { stat: { total_deleted_cars: @stat.total_deleted_cars, total_deleted_rentals: @stat.total_deleted_rentals, total_deleted_users: @stat.total_deleted_users } }
    end

    assert_redirected_to stat_url(Stat.last)
  end

  test "should show stat" do
    get stat_url(@stat)
    assert_response :success
  end

  test "should get edit" do
    get edit_stat_url(@stat)
    assert_response :success
  end

  test "should update stat" do
    patch stat_url(@stat), params: { stat: { total_deleted_cars: @stat.total_deleted_cars, total_deleted_rentals: @stat.total_deleted_rentals, total_deleted_users: @stat.total_deleted_users } }
    assert_redirected_to stat_url(@stat)
  end

  test "should destroy stat" do
    assert_difference('Stat.count', -1) do
      delete stat_url(@stat)
    end

    assert_redirected_to stats_url
  end
end
