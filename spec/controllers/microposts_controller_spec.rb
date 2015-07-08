require 'rails_helper'
RSpec.describe MicropostsController, :type => :controller do

  # Typical user login 
  describe 'user access' do
  	# Sample account with a micropost and a recipient
    before :each do
  	  user = FactoryGirl.create(:user, :with_micropost_and_recipient)
  	  log_in(user)
    end
  end

  describe 'GET #home'
    # User logging into home and seeing a list of followed's and personal tasks (microposts)
    it "populates an array of followed's tasks (microposts) by most recent date" do
  end

  
  describe 'POST #schedule' do
  	it "only at time specified by its scheduled_time column" do
  	  expect logged_in?.to eq(true)
  	  valid_SMS_form_input
  	  expect(Delayed::Job.count).to eq(1)
  	  scheduled_time_of_test_sms = Time.utc(2015, 7, 6, 22, 0, 0)
  	  expect(Micropost.first.scheduled_time).to eq(scheduled_time_of_test_sms)
  	  Timecop.travel(Time.now + 5.days)
  	  successes, failures = Delayed::Worker.new.work_off
  	  expect(successes).to eq(1)
  	  expect(failures).to eq(0)
  	  expect(Delayed::Job.count).to eq(0)
  	  expect(Micropost.first.sms_sent).to eq(true)
  	end
  end

end
	
  # ARCHIVE TESTS
  #
  # # Remember to update scheduled time if testing
  # describe 'will schedule and send sms' do
  # 	before :each do
  # 	  test_time = Time.utc(2015, 7, 6, 22, 0, 0)
  # 	  Timecop.freeze(test_time)
  # 	end
  # 	after(:each) { Timecop.return }
