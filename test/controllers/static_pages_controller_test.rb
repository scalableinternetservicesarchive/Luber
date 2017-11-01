require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  test "should get home" do
    get home_url
    assert_response :success
    assert_select "title", "Home | Luber"
  end

  test "should get faq" do
    get faq_url
    assert_response :success
    assert_select "title", "FAQ | Luber"
  end

  test "should get about" do
    get about_url
    assert_response :success
    assert_select "title", "About | Luber"
  end

  test "should get contact" do
    get contact_url
    assert_response :success
    assert_select "title", "Contact | Luber"
  end

  test "should get privacy" do
    get privacy_url
    assert_response :success
    assert_select "title", "Privacy Policy | Luber"
  end

end
