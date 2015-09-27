# This is a realistic user experience integration test

require "rails_helper"

feature "User lands on landing page for the first time ever" do 
  scenario "they see proper landing page content" do
  	visit root_path

  	# Ensure all links are there
  	expect(page).to have_link("Home")
  	expect(page).to have_link("Log in")
  	expect(page).to have_link("Sign up now!")
  	expect(page).to have_link("About")
  	expect(page).to have_link("Contact")

  	# Ensure business pitch is there
  	expect(page).to have_content('Study for five hours. Write 200 words a night. Go for a morning run.')
  	expect(page).to have_content('Set your goals. Complete them. Check in before the end of the day. Miss a goal and your friends receive a text. It\'s that simple. Get stuff done.')
  	expect(page).to have_content('Created by Sze Chan 2015.')
  end

  scenario "they click on signup and create a new user" do
  	visit root_path

  	click_link "Sign up now!"
  	expect(current_path).to eq(signup_path)
  	expect(page).to have_content("Sign up")

  	expect{
  		fill_in('First name', :with => 'John')
  		fill_in('Last name', :with => 'Smith')
  		fill_in('Email', :with => 'crispygringo@mexicanborder.com')
  		fill_in('Password', :with => 'francesha')
  		fill_in('Confirmation', :with => 'francesha')
  		click_button "Create my account"
  	}.to change(User, :count).by(1)
  	
  	expect(current_path).to eq(root_path)
  end

  scenario "brand new unverified user" do
    unverified_user = create(:user,
      activated: nil,
      phone_verified: nil
      )
    visit root_path
    click_link 'Log in'
    fill_in 'Email', with: unverified_user.email
    fill_in 'Password', with: unverified_user.password
    click_button 'Log in'
    expect(page).to have_content('Account not activated. Check your email for the activation link.')
  end

  scenario "unverified user's first time logging in with no phone" do
    verified_user_no_phone = create(:user,
      activated: true,
      phone_verified: nil
      )
    visit root_path
    click_link 'Log in'
    fill_in 'Email', with: verified_user_no_phone.email
    fill_in 'Password', with: verified_user_no_phone.password
    click_button 'Log in'
    expect(page).to have_content('Verify Your Phone Via SMS')
  end

  scenario "adds a new micropost with two associated recipients and began delayed job" do
    user = create(:user)
    micropost = create(:micropost)

    visit root_path
    click_link 'Log in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
    expect(page).to have_content('Create goal with a verb and subject:')

    # Making a new goal with valid input
    visit root_path
    expect{
      fill_in 'micropost_title', with: micropost.title
      fill_in 'micropost_content', with: micropost.content
      find('#micropost_days').find(:days_to_complete, 'option[3]').select_option
      #fill_in 'recipients', with: recipients # Check box
      click_button 'Post'
    }.to change(Micropost, :count).by(1)

    # Check redirect and displaying new content on page
    #expect(current_path).to eq root_path
    #expect(page).to have_content(micropost.title)
  end
end