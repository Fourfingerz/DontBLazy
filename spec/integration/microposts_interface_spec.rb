require 'rails_helper'

feature "Adding recipients for Microposts" do
  scenario "adds a new micropost with two associated recipients" do

  user = create(:user)
  @content = create(:micropost_recipient, user: user) # instanced so can be called from helpers
  log_in(user)

 end
end