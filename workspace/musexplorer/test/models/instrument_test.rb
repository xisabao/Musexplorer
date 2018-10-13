require 'test_helper'

class InstrumentTest < ActiveSupport::TestCase
  def setup
  	@instrument = build(:instrument)
  end

  test "should be valid" do
  	assert @instrument.valid?
  end

  test "name should be present" do
  	@instrument.name = ""
  	assert_not @instrument.valid?
  end
  test "name should be unique" do
    duplicate_instrument = @instrument.dup
    @instrument.save
    assert_not duplicate_instrument.valid?
  end
end
