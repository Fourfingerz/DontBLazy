require 'rails_helper'

feature "User form" do
  scenario "user verifies a phone before she can submit form" do
    user = create(:user)

    # Home page login
    visit root_path
    click_link 'Log in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    # Make sure fresh user SANS phone_number sees add_phone form
    fill_in 'user_phone_number', with: '00000000'
    click_button 'send-pin-link'

    fill_in 'user_phone_pin', with: '0000'
    click_button 'verify-pin-link'

    # Now she can make a new goal with a number.
    visit root_path
    expect{
      fill_in 'micropost_content', with: micropost.content
      select '2 days (two check-ins)', from: 'micropost_schedule_time'
      #fill_in 'recipients', with: recipients # Check box
      click_button 'Post'
    }.to change(Micropost, :count).by(1)
    expect(current_path).to eq root_path
  end
end