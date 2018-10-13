require 'test_helper'

class EraTest < ActiveSupport::TestCase
  def setup
  	@era = build(:era)
  end
  test "should be valid" do
  	assert @era.valid?
  end
  test "name should be present" do
  	@era.name = ""
  	assert_not @era.valid?
  end
  test "name should be unique" do
  	duplicate_era = @era.dup
  	@era.save
  	assert_not duplicate_era.valid?
  end
end
