require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "Home | Luber"

  end

  test "should get faq" do
    get static_pages_faq_url
    assert_response :success
    assert_select "title", "FAQ | Luber"
  end

  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "About | Luber"
  end

  test "should get contact" do
    get static_pages_contact_url
    assert_response :success
    assert_select "title", "Contact | Luber"
  end

  test "should get privacypolicy" do
    get static_pages_privacypolicy_url
    assert_response :success
    assert_select "title", "Privacy Policy | Luber"
  end

end
