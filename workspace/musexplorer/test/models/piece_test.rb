require 'test_helper'

class PieceTest < ActiveSupport::TestCase
  def setup
  	@piece = build(:piece)
  end

  test "should be valid" do
  	assert @piece.valid?
  end

  test "name should be present" do
  	@piece.name = nil
  	assert_not @piece.valid?
  end

  test "composer_id should be present" do
  	@piece.composer_id = nil
  	assert_not @piece.valid?
  end

end
