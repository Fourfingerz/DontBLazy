class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  # DBL
  has_many :recipients, dependent: :destroy
  serialize :current_tasks_map
  serialize :microposts_due_queue

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Returns a user's status feed.
  def feed
    following_ids_subselect = "SELECT followed_id FROM relationships
                               WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids_subselect})
                     OR user_id = :user_id", user_id: id)
  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  # DBL

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

  # Pin for phone verification.
  def generate_pin
    self.phone_pin = rand(0000..9999).to_s.rjust(4, "0")
    save
  end

  def send_pin
    @twilio_client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"])
    @twilio_client.messages.create(
      to: phone_number,
      from: ENV["TWILIO_PHONE_NUMBER"],
      body: "Your verification PIN is #{phone_pin}"
    )
  end

  def verify(entered_pin)
    update(phone_verified: true) if self.phone_pin == entered_pin
  end

    # UNTESTED by Rspec
  # Send user's phone a SMS list of active goals menu on create
  def create_status_sms
    goals = self.microposts.where(:active => true)  # finds user's ACTIVE goals 

    # This one is stored as a map in the DB
    id_arr = [], i = 0
    goals.each do |goal|
      i += 1
      id = { "task" => i, "micropost id" => goal.id }
      id_arr << id    # Maps corresponding numbers to IDs
                      # [{"task"=>1, "micropost id"=>9}, {"task"=>2, "micropost id"=>8}, 
                      #  {"task"=>3, "micropost id"=>7}, {"task"=>4, "micropost id"=>6}]
    end
    self.current_tasks_map = id_arr.flatten.drop(1)  # Saves ID map to user column
    self.save

    # This one is for the user to check-in via SMS
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
    active_goals.slice! "0"  # Temporary solution for annoying ZERO
    active_goals_summary = "DontBLazy App: Reply with corresponding number to check in your goals. For multiple check-ins, separate by comma. ex 1,2,3. Your Goals:" + active_goals
  end

  def send_status_sms 
    status_sms = self.create_status_sms
    # IF/ELSE to determine if there are active projects and send texts accordingly
    if status_sms =~ /\d/
      send_text_message(status_sms, self.phone_number)
    else
      no_current_tasks_sms = "You don't have any pending tasks!"
      send_text_message(no_current_tasks_sms, self.phone_number)
    end
  end

  # UNTESTED BY RSPEC
  def stage_or_queue_occupied_by(micropost_id)
    id = micropost_id.to_s
    # Does the stage contain the micropost? The queue?
    self.micropost_id_due_now.to_s.include?(id) or self.microposts_due_queue.to_s.include?(id)
  end

  private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
