require "rails_helper"

feature "User lands on landing page" do 
  scenario "they see a signup button" do
  	visit root_path

  	expect(page).to have_link("Sign up now!")
  end

end