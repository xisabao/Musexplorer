require 'test_helper'

class TagTest < ActiveSupport::TestCase
  def setup
  	@tag = build(:tag)
  end
  test "should be valid" do
  	assert @tag.valid?
  end
  test "name should be present" do
  	@tag.name = ""
  	assert_not @tag.valid?
  end
  test "name should be unique" do
  	duplicate_tag = @tag.dup
  	@tag.save
  	assert_not duplicate_tag.valid?
  end
end
