require 'rails_helper'

describe "New DBL features for Micropost form" do
  before(:each) do
    user = create(:user)
    @content = create(:micropost_recipient, user: user) # instanced so can be called from helpers
    log_in(user)
  end

  describe "micropost interface" 
    # Checks if interface correctly posts data to DB that makes gears turn
    it "saves to the db correctly with micropost input sans RECIPIENTS"
    it "saves to the db correctly with micropost data with RECIPIENTS"
end