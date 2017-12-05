require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      username: "ExampleUser", 
      email:"user@example.com",
      password: "password", 
      password_confirmation: "password",
      first_name: "Bob", 
      last_name: "Jones", 
      city: "Goleta", 
      state: "CA", 
      admin: false, 
      signed_in_at: "2017-11-30 10:55:36" )
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.username = "        "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "          "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.username = "a"*33
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a"*255 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com bigLITTLE@derp.COM wea.rcn.u@earol.co.uk
      alice+bob@baz.car hello_world@afece.acxd]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_addresses.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[poop*pee@gmail.com foo@bar..com george.com w@q.com@u.org
      jokes@on+u.c++ /jello/tastes/weird@bar.co.uk]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower case" do
    mixed_case_email = "wUBBa_LuBbA@DUb.DDUUuUB"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " "*8
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a"*5
    assert_not @user.valid?
  end

  test "db seed file: in test env, each user should have same positive num of rentals" do
    Rails.application.load_seed
    r = Rental.where(user_id: User.last.id).count
    assert_operator r, :>, 0
    User.all.each do |u|
      assert_equal Rental.where(user_id: u.id).count, r
    end
  end
end
