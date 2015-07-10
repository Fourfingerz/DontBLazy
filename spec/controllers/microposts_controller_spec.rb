require 'rails_helper'
RSpec.describe MicropostsController, :type => :controller do
  
  before(:each) do
    user = create(:user)
    @content = create(:micropost_recipient, user: user) # instanced so can be called from helpers
    log_in(user)
  end

  describe 'GET #home'
    # User logging into home and seeing a list of followed's and personal tasks (microposts)
    it "shows followed's ACTIVE tasks (microposts) by most recent date"
    it "doesn't show followed's INACTIVE tasks (microposts)"
    it "shows personal ACTIVE tasks (microposts) sorted by DAILY schedule_time nearest end"

  describe 'GET #micropost'
    # Click on individual task (micropost) for task info page \ PAUSE \ KILLSWITCH functionality
    it "shows all info on task (micropost)"
    it "shows all task's recipients"
    it "has button to START inactive/new task"
    it "has link to KILL active task (immediate failure)"

  describe 'POST BUTTON #start_micropost_task' 
  	it "only at time specified by its scheduled_time column" do
  	  expect(logged_in?).to eq(true)
  	  expect(recipients_present?(@content)).to eq(true)
      # all systems go, start core functionality
  	  expect(Delayed::Job.count).to eq(1)
  	  scheduled_time_of_test_sms = Time.utc(2015, 7, 15, 22, 0, 0)
  	  expect(Micropost.first.scheduled_time).to eq(scheduled_time_of_test_sms)
  	  Timecop.travel(Time.now + 5.days)
  	  successes, failures = Delayed::Worker.new.work_off
  	  expect(successes).to eq(1)
  	  expect(failures).to eq(0)
  	  expect(Delayed::Job.count).to eq(0)
  	  expect(Micropost.first.sms_sent).to eq(true)
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
