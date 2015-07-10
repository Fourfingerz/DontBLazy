require 'rails_helper'

describe "New DBL features for Micropost form" do
  before(:each) do
    user = create(:user)
    @content = create(:micropost_recipient, user: user) # instanced so can be called from helpers
    log_in(user)
  end

  context "when I write a new micropost with new dropdown schedule_time" do
    it "does amazing things"
  end
end