require 'test_helper'

class TagTest < ActiveSupport::TestCase
  def setup
    @tag = Tag.create!(name: "Sporty")
  end


  test "reject invalid tags " do
    @tag.name = "gas~!"
    assert_not @tag.valid?
  end

  test "tag name should be present" do
    @tag.name = "   "
    assert_not @tag.valid?
  end

  test "tags should be saved as lower case" do
    mixed_case_tags= "sUnRoof"
    @tag.name = mixed_case_tags
    @tag.save
    assert_equal mixed_case_tags.downcase, @tag.reload.name
  end
end
