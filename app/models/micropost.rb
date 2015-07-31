class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size
  # DBL
  has_many :micropost_recipients, dependent: :destroy
  has_many :recipients, through: :micropost_recipients
  validates :days_to_complete, presence: true
  after_create :set_initial_state
  after_create :schedule_check_in_deadline

  # DBL Logic

  # To run daemon:
  # bin/delayed_job start

  # To find status:
  # bin/delayed_job status

  # To delete all DJs:
  # rake jobs:clear 

  # Tested by hand
  # UNTESTED BY RSPEC
  # Sets a default state for every freshly minted Micropost (goal)
  def set_initial_state
    self.check_in_current = false
    self.days_completed = 0
    self.days_remaining = self.days_to_complete
    self.current_day = 1
    self.active = true
    self.save
  end

  # Tested by hand
  # UNTESTED BY RSPEC
  def good_check_in_tally
    if self.days_remaining > 0
      self.days_completed += 1  # DB Column
      self.days_remaining -= 1  # DB Column
      self.current_day += 1     # DB Column
      self.check_in_current = false  # Sets this column for next day
      self.save
    end
  end

  # Tested by hand
  # UNTESTED BY RSPEC
  def bad_check_in_tally
    if self.days_remaining > 0
      self.days_remaining -= 1  # DB Column
      self.current_day += 1     # DB Column
      self.check_in_current = false  # Sets this column for next day
      self.save
    end
  end

  # Tested by hand
  # UNTESTED BY RSPEC
  def send_check_in_sms 
    # Find id number value that matches key of map
    activity = self.title
    check_in_sms = "DontBLazy Bot: Time's up! Did you do your task: " + activity + "? Reply YES or NO. (You have two hours to respond)"
    send_text_message(check_in_sms, user.phone_number)
  end

  # UNTESTED BY RSPEC and HAND
  # Testing to see if there is anything on stage
  def any_goals_on_stage?
    user = User.find_by(:id => self.user_id)
    user.micropost_id_due_now?
  end

  # UNTESTED BY RSPEC and HAND
  # The "stage" is the task chosen pending YES and NO reply in SMS
  def go_on_stage
    # Sets micropost ID that is in question at due date.
    user = User.find_by(:id => self.user_id)
    user.micropost_id_due_now = self.id  # Set the current task ON STAGE
    user.save
  end

  # UNTESTED BY RSPEC and HAND
  # The "queue" is where tasks go if stage is occupied
  def go_on_queue
    user = User.find_by(:id => self.user_id)
    id_in_string = self.id.to_s
    user.microposts_due_queue ||= []
    user.microposts_due_queue << id_in_string
    user.save
  end

  # UNTESTED BY RSPEC and HAND
  # Set INACTIVE if no more days remaining
  def check_if_still_active
      self.active = false if self.days_remaining < 1
      self.save
  end

  # UNTESTED BY RSPEC and HAND
  # After 2 hours from deadline, awaiting YES/NO or two hour expires
  def two_hour_check_in
    user = User.find_by(:id => self.user_id)
    if self.late_but_current == true
      good_check_in_tally
      check_if_still_active
      user.micropost_id_due_now = nil
      queue_check
    else
      bad_check_in_tally
      # send_bad_news_to_recipients # FUTURE implimentation
      check_if_still_active
      user.micropost_id_due_now = nil
      queue_check
    end
  end

  # UNTESTED BY RSPEC and HAND
  def schedule_two_hour_check_in
    job = self.delay(run_at: 2.hours.from_now).two_hour_check_in
    update_column(:delayed_job_id, job.id)

    Delayed::Job.find_by(:id => job.id).update_columns(owner_type: "Micropost")  # Associates delayed_job with Micropost ID
    Delayed::Job.find_by(:id => job.id).update_columns(owner_id: self.id)
  end

  # UNTESTED BY RSPEC and HAND
  # Checks queue and hustles next task on stage if exists
  def queue_check
    user = User.find_by(:id => self.user_id)
    if !user.microposts_due_queue.blank?
      first_in_queue = user.microposts_due_queue.first  # takes first in line
      user.micropost_id_due_now = first_in_queue  # goes up on stage
      user.microposts_due_queue.shift  # removes self from line
      user.save
    end
  end

  # Tested by hand
  # UNTESTED BY RSPEC
  def send_day_completed_sms
    user = User.find_by(:id => self.user_id)
    activity = self.title
    day_completed_message = "Thank you for checking in to your task: " + activity + "!"
    send_text_message(day_completed_message, user.phone_number)
  end

  # Tested by hand
  # UNTESTED BY RSPEC
  def send_day_incomplete_sms
    user = User.find_by(:id => self.user_id)
    activity = self.title
    day_incomplete_message = "Sorry to hear that you missed your task: " + activity + ". Recipients of your choosing have been notified. Tell them to be nice! You're trying!"
    send_text_message(day_incomplete_message, user.phone_number)
  end

  # Tested by hand
  # UNTESTED BY RSPEC
  # After 24 hours, DBL runs this check-in
  def check_in ### fix this
    # User already checked in thru SMS before deadline
    if self.check_in_current == true  
      good_check_in_tally
      check_if_still_active
      schedule_check_in_deadline  # After 24 hours, restart another delayed_job if there are more days
    else 
    # User has NOT checked in via SMS or website and is NOW DUE
      if any_goals_on_stage? # If there is already something on stage
        go_on_queue
        schedule_two_hour_check_in
        schedule_check_in_deadline
      else  # If stage has nil, go on stage for pending SMS reply
        go_on_stage
        schedule_two_hour_check_in
        send_check_in_sms
        schedule_check_in_deadline
      end
    end
  end

  # UNTESTED BY RSPEC
  # Schedule multiple delayed job based on number of days and task
  def schedule_check_in_deadline
    if self.days_remaining > 0
      # job = self.delay(run_at: 24.hours.from_now).check_in # RUN THIS JOB AFTER SCHEDULED TIME

      job = self.delay(run_at: 3.minutes.from_now).check_in
      update_column(:delayed_job_id, job.id)  # Update Delayed_job

      Delayed::Job.find_by(:id => job.id).update_columns(owner_type: "Micropost")  # Associates delayed_job with Micropost ID
      Delayed::Job.find_by(:id => job.id).update_columns(owner_id: self.id)
      send_user_status_sms
    end
  end

  # Provides mapping of goals with active deadlines
  def send_user_status_sms
    user = User.find_by(:id => self.user_id)
    user.send_status_sms
  end

  # 
  def delayed_job
    Delayed::Job.find(delayed_job_id)
  end

  # Twilio magic
  def send_text_message(content, target_phone)

    twilio_sid = ENV["TWILIO_ACCOUNT_SID"]
    twilio_token = ENV["TWILIO_AUTH_TOKEN"]
    twilio_phone_number = ENV["TWILIO_PHONE_NUMBER"]

    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

      @twilio_client.messages.create(
        :from => twilio_phone_number,
        :to => target_phone,
        :body => content
      )
  end

  # Associates Delayed Jobs with "owners" models
  def foo
  end
  handle_asynchronously :foo, :owner => Proc.new { |o| o  }
  
  private
  
    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
