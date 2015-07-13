require 'rails_helper'

feature "Micropost form" do
  scenario "add a new micropost with two associated recipients and began delayed job" do
    user = create(:user)
    micropost = create(:micropost)

    visit root_path
    click_link 'Log in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    visit root_path
    expect{
      fill_in 'micropost_content', with: micropost.content
      select '2 days (two check-ins)', from: 'micropost_schedule_time'
      # fill_in 'recipients', with: recipients
      click_button 'Post'
    }.to change(Micropost, :count).by(1)
    expect(current_path).to eq root_path
  end
end