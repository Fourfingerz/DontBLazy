require 'rails_helper'

describe RecipientsController do
  
  describe 'GET #index' do
  	context 'with params[:letter]' do
  	  it "populates an array of user's recipients starting with the letter"
  	  it "renders the :index user's recipient template"
  	end

  	context 'without params[:letter]' do
  	  it "populates an array of all context with pagination"
  	  it "renders the :index user's recipient template"
  	end
  end

  describe 'GET #show' do
  	it "assigns the requested recipient to @recipient"
  	it "renders the :show template"
  end

  describe 'GET #new' do
  	it "assigns a new Recipient to @contact"
  	it "renders the :new template"
  end

  describe 'GET #edit' do
  	it "assigns the requested recipient to @recipient"
  	it "renders the :edit template"
  end

  describe "POST #create" do
  	context "with valid attributes" do
  	  it "saves the new recipient in the database"
  	  it "redirects to recipients#show"
  	end

  	context "with invalid attributes" do
  	  it "does not save the new recipient in the database"
  	  it "re-renders the :new template"
  	end
  end

  describe 'PATCH #update' do
  	context "with valid attributes" do
  	  it "updates the recipient in the database"
  	  it "redirects to the recipient"
  	end

  	context "with invalid attributes" do
  	  it "does not update the recipient"
  	  it "re-renders the #edit template"
  	end
  end

  describe 'DELETE #destroy' do
  	it "deletes the recipient from the database"
  	it "redirects to root_url"
  end
end