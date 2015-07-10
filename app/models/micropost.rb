class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size
  # DBL
  has_many :micropost_recipients, dependent: :destroy
  has_many :recipients, through: :micropost_recipients
  validates :schedule_time, presence: true
  #after_create :schedule_deadline_text

  # DBL Logic

  # Deadline SMS content
  def deadline_text_content
    self.content # for now, write customized message later
  end

  # Schedules a SMS sent out at deadline.
  def schedule_deadline_text
    job = self.delay(run_at: self.schedule_time).send_text_messages(deadline_text_content)
    update_column(:delayed_job_id, job.id)
  end

  def delayed_job
    Delayed::Job.find(delayed_job_id)
  end

  # Twilio magic
  def send_text_message(content)
    phones = self.recipients.map(&:phone)

    twilio_sid = ENV["TWILIO_ACCOUNT_SID"]
    twilio_token = ENV["TWILIO_AUTH_TOKEN"]
    twilio_phone_number = ENV["TWILIO_PHONE_NUMBER"]

    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    phones.each do |recipient_phone|
      @twilio_client.messages.create(
        :from => twilio_phone,
        :to => recipient_phone,
        :body => content
      )
    end
  end
  
  private
  
    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
