require 'rails_helper'
RSpec.describe RecipientsController, :type => :controller do

  before(:each) do
    user = create(:user)
    @content = create(:micropost_recipient, user: user)
    log_in(user)
  end

#   # Shows all of USER'S RECIPIENTS
#   describe 'GET #show' do
#   	it "assigns the requested USER'S recipients to @recipients" do
#   	  recipient = create(:recipient)
#   	  get :show, id: recipient
#   	  expect(assigns(:recipient)).to eq recipient
#   	end
#   end
  
#   	it "renders the :show template" do
#   	  recipient = create(:user_with_recipient)
#   	  get :show, id: recipient
#   	  expect(response).to render_template :show
#   	end
#   end

#   # User can add 
#   describe 'GET #new'
#   	it "assigns a new Recipient to @contact" do
#   	  get :new
#   	  expect(assigns(:recipient)).to be_a_new(Recipient)
#   	end

#   	it "renders the :new template" do
#   	  get :new
#   	  expect(response).to render_template :new
#   	end

#   describe 'GET #edit'
#   	it "assigns the requested USER'S recipients to @recipients" do
#   	  recipient = create(:user)
#   	  get :show, id: user
#   	  expect(assigns(:user)).to eq user
#   	end

#   	it "assigns the requested USER RECIPIENT to @recipient" do
#   	  recipient = create(:user_with_recipient)
#   	  get :edit, id: recipient
#   	  expect(assigns(:recipient)).to eq recipient
#   	end

#   	it "renders the :edit template" do
#   	  recipient = create(:user_with_recipient)
#   	  get :edit, id: recipient
#   	  expect(response).to render_template :edit
#   	end

#   describe "POST #create"
#   	context "with valid attributes" do
#   	  it "saves the new recipient in the database"
#   	  it "redirects to recipients#show"
#   	end

#   	context "with invalid attributes" do
#   	  it "does not save the new recipient in the database"
#   	  it "re-renders the :new template"
#   	end

#   describe 'PATCH #update' 
#   	context "with valid attributes" do
#   	  it "updates the recipient in the database"
#   	  it "redirects to the recipient"
#   	end

#   	context "with invalid attributes" do
#   	  it "does not update the recipient"
#   	  it "re-renders the #edit template"
#   	end

#   describe 'DELETE #destroy' 
#   	it "deletes the recipient from the database"
#   	it "redirects to root_url"
 end
