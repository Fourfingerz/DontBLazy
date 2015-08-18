# Micropost.rb

# August 18, 2015

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

    # Logic here NOT TO REPLICATE ITSELF
    id_in_string = self.id.to_s
    user.microposts_due_queue ||= []
    # Checks to see if self's id already exists before joining queue
    user.microposts_due_queue << id_in_string if !user.microposts_due_queue.any? {|queue| queue.include?(id_in_string)}
    user.save
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

    # UNTESTED BY RSPEC
  # Checks to see if selected Micropost is NOT already checked in
  def fresh_and_not_checked_in?
    !false ^ self.check_in_current && !false ^ self.late_but_current
    # returns TRUE if it's CLEAN and hasn't been checked into
  end

