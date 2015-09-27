require 'rails_helper'

feature "User form" do
  scenario "user verifies a phone before she can submit form" do
    verified_user_no_phone = create(:user,
      phone_number: nil,
      phone_verified: nil
      )
    visit root_path
    click_link 'Log in'
    fill_in 'Email', with: verified_user_no_phone.email
    fill_in 'Password', with: verified_user_no_phone.password
    click_button 'Log in'

    expect(page).to have_content('Let\'s Verify Your Phone Via SMS:')

    # Make sure fresh user SANS phone_number sees add_phone form
    # fill_in 'verify-phone', with: '0000000000'
    # click_button 'Send Verification PIN'

    # fill_in 'verify_pin_number', with: '0000'
    # click_button 'Verify PIN'

    # expect(page).to have_content('Create goal with a verb and subject:')
  end
end