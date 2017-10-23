require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @suff = "| Luber"
  end

  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "Home #{@suff}"

  end

  test "should get faq" do
    get static_pages_faq_url
    assert_response :success
    assert_select "title", "FAQ #{@suff}"
  end

  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "About #{@suff}"
  end

  test "should get contact" do
    get static_pages_contact_url
    assert_response :success
    assert_select "title", "Contact #{@suff}"
  end

  test "should get privacypolicy" do
    get static_pages_privacypolicy_url
    assert_response :success
    assert_select "title", "Privacy Policy #{@suff}"
  end

end
