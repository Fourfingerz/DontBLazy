require 'test_helper'

class RecipientTest < ActiveSupport::TestCase
  def setup
    @recipient = recipients(:self)
  end

  test "should be valid" do
    assert @recipient.valid?
  end

  test "recipient should belong to a user" do
    @recipient.user_id = nil
    assert_not @recipient.valid?
  end

  test "recipient phone should be present and formatted properly" do
    @recipient.phone = "   "
    assert_not @recipient.valid?
  end

  test "recipient name should not be shorter than 3 characters" do
    @recipient.name = "ab"
    assert_not @recipient.valid?
  end

  test "order should be most recent first" do
    assert_equal recipient.first, recipients(:most_recent)
  end
end
