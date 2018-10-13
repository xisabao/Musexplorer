require 'test_helper'

class ReplyTest < ActiveSupport::TestCase
  def setup
  	@reply = build(:reply)
  end
  test "should be valid" do
  	assert @reply.valid?
  end
end
