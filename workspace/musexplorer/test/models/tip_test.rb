require 'test_helper'

class TipTest < ActiveSupport::TestCase
  def setup
  	@tip = build(:tip)
  end
  test "should be valid" do
  	assert @tip.valid?
  end
  test "piece_id should be present" do
  	@tip.piece_id = nil
  	assert_not @tip.valid?
  end
  test "user_id should be present" do
  	@tip.user_id = nil
  	assert_not @tip.valid?
  end
  test "body should be present" do
  	@tip.body = ""
  	assert_not @tip.valid?
  end
end
