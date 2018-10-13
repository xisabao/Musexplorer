require 'test_helper'

class ComposerTest < ActiveSupport::TestCase
  def setup
    @composer = build(:composer)
  end
  test "should be valid" do
    assert @composer.valid?
  end
  test "name should be present" do
    @composer.name = "  "
    assert_not @composer.valid?
  end

end
