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
  after_create :schedule_check_in_deadlines
  after_create :send_status_sms

  # DBL Logic

  # UNTESTED BY RSPEC
  def good_check_in_tally
    self.days_completed += 1  # DB Column
    self.days_remaining -= 1  # DB Column
    self.current_day += 1     # DB Column
    self.check_in_current = false  # Sets this column for next day
    self.save
  end

  # UNTESTED BY RSPEC
  def bad_check_in_tally
    self.days_remaining -= 1  # DB Column
    self.current_day += 1     # DB Column
    self.check_in_current = false  # Sets this column for next day
    self.save
  end

  # UNTESTED BY RSPEC
  def send_check_in_sms
    user = User.find_by(:id => self.user_id)
    user.micropost_id_due_now = self.id  # Set the current task ID being PROMPTED about

    # Find id number value that matches key of map
    activity = self.title
    check_in_sms = "DontBLazy Bot: Time's up! Did you do your task: " + activity + "? Reply YES or NO."
    send_text_message(check_in_sms, user.phone_number)
  end

  # UNTESTED BY RSPEC
  # When user sends SMS gibberish and is not understood, this will go out.
  def send_bad_entry_sms
    user = User.find_by(:id => self.user_id)
    if @from_number == user.phone_number
      try_again_sms = "Try again with a valid entry."
      send_text_message(try_again_sms, user.phone_number)
    end
  end

  # UNTESTED BY RSPEC
  def send_day_completed_sms
    user = User.find_by(:id => self.user_id)
    activity = self.title
    day_completed_message = "Thank you for checking in to your task: " + activity + "!"
    send_text_message(day_completed_message, user.phone_number)
  end

  # UNTESTED BY RSPEC
  # Sets a default state for every freshly minted Micropost (goal)
  def set_initial_state
    self.check_in_current = false
    self.days_completed = 0
    self.days_remaining = self.days_to_complete
    self.current_day = 1
  end

  # UNTESTED BY RSPEC
  # After 24 hours, DBL runs this check-in
  def check_in
    if self.check_in_current == true  # User already checked in thru SMS before deadline
      good_check_in_tally
    else 
      send_check_in_sms
    end
  end

  # UNTESTED BY RSPEC
  # Schedule multiple delayed job based on number of days and task
  def schedule_check_in_deadlines
    number_of = 1
    self.days_to_complete.downto(1) do |n|  # Value from column
      job = self.delay(run_at: Time.now + number_of.days.from_now).check_in # DO THIS JOB AFTER SCHEDULED TIME
      update_column(:delayed_job_id, job.id)
      number_of += 1
    end
  end

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

  # UNTESTED by Rspec
  # Send user's phone a SMS list of active goals menu on create
  def send_status_sms
    user = User.find_by(:id => self.user_id)
    goals = user.microposts

    id_arr = [], i = 0
    goals.each do |goal|
      i += 1
      count = i.to_s
      ids = Hash[count => goal.id.to_s]
      id_arr << ids    # Maps corresponding numbers to IDs
                          #   [{"1"=>"9"}, {"2"=>"8"}, {"3"=>"7"}, {"4"=>"6"}
    end
    user.current_tasks_map = id_arr  # Saves ID map to user column
    user.save

    sms_arr = [], j = 0
    goals.each do |goal|
      j += 1
      count = j.to_s
      sms = count + ". " + goal.title
      sms_arr << sms   # Generates goals map for user SMS
                          #   ["1 Medical Volunteering", 
                          #    "2 Himalayan Altitude Acclimatization", 
                          #    "3 Rowing Session", "4 Yoga Session"]
    end
    active_goals = sms_arr.join(" ")
    active_goals_summary = "To mark goals complete before deadline, REPLY with your goal's corresponding number, separated by a space: " + active_goals
    send_text_message(active_goals_summary, user.phone_number)
  end
  
  private
  
    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
