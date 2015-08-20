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

  # UNTESTED BY RSPEC and HAND
  # Set INACTIVE if no more days remaining
  def check_if_still_active
    if self.days_remaining == 0
      self.active = false 
      self.save

      # Finds referenced micropost from user's map and deletes itself
      user = User.find_by(:id => self.user_id)
      user.current_tasks_map = user.current_tasks_map.delete_if {|h| h["micropost id"] == self.id}
      user.save

      # Finds and removes all associated Delayed Jobs still lurking in the system
      garbage_jobs = Delayed::Job.where(:owner_type => "Micropost", :owner_id => self.id)
      garbage_jobs.each do |job|
        job.delete
      end
    else
      schedule_new_day  # After 24 hours, reschedule another 24 hour check_in and 4 hour reminder
    end
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
      user.save
    else
      bad_check_in_tally
      # send_bad_news_to_recipients # FUTURE implimentation
      check_if_still_active
      user.micropost_id_due_now = nil
      queue_check
      user.save
    end
  end

  # UNTESTED BY RSPEC and HAND
  def schedule_two_hour_check_in_deadline
    # TEST CUT TIME
    job = self.delay(run_at: 3.minutes.from_now).two_hour_check_in

    # job = self.delay(run_at: 2.hours.from_now).two_hour_check_in
    update_column(:delayed_job_id, job.id)

    Delayed::Job.find_by(:id => job.id).update_columns(owner_type: "Micropost")  # Associates delayed_job with Micropost ID
    Delayed::Job.find_by(:id => job.id).update_columns(owner_job_type: "Micropost Two Hour Deadline")
    Delayed::Job.find_by(:id => job.id).update_columns(owner_id: self.id)
    Delayed::Job.find_by(:id => job.id).update_columns(user_id: self.user_id)
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
      user.save
    else
      bad_check_in_tally
      # send_bad_news_to_recipients # FUTURE implimentation
      check_if_still_active
      user.micropost_id_due_now = nil
      queue_check
      user.save
    end
  end


    # Tested by hand
  # UNTESTED BY RSPEC
  # After 24 hours, DBL runs this check-in
  def check_in 
    # User already checked in thru SMS before deadline
    if self.check_in_current == true  
      good_check_in_tally
      check_if_still_active
    else 
    # User has NOT checked in via SMS or website and is NOW DUE
      if any_goals_on_stage? # If there is already something on stage
        go_on_queue
        schedule_two_hour_check_in_deadline
        schedule_check_in_deadline
      else  # If stage has nil, go on stage for pending SMS reply
        go_on_stage
        schedule_two_hour_check_in_deadline
        send_check_in_sms
        schedule_check_in_deadline
      end
    end
  end

    # Tested by hand
  # UNTESTED BY RSPEC
  def send_check_in_sms 
    # Find id number value that matches key of map
    activity = self.title
    current_day = self.current_day.to_s
    check_in_sms = "DontBLazy Bot: Time's up! Did you do day " + current_day + " of your task: " + activity + "? Reply YES or NO. (You have two hours to respond)"
    send_text_message(check_in_sms, user.phone_number)
  end  

    # UNTESTED BY RSPEC and HAND
  def schedule_two_hour_check_in_deadline
    # TEST CUT TIME
    job = self.delay(run_at: 3.minutes.from_now).two_hour_check_in

    # job = self.delay(run_at: 2.hours.from_now).two_hour_check_in
    update_column(:delayed_job_id, job.id)

    Delayed::Job.find_by(:id => job.id).update_columns(owner_type: "Micropost")  # Associates delayed_job with Micropost ID
    Delayed::Job.find_by(:id => job.id).update_columns(owner_job_type: "Micropost Two Hour Deadline")
    Delayed::Job.find_by(:id => job.id).update_columns(owner_id: self.id)
    Delayed::Job.find_by(:id => job.id).update_columns(user_id: self.user_id)
  end




# microposts_controller.rb

# August 19, 2015

class MicropostsController < ApplicationController
  #skip_before_filter :force_ssl # check later if needed
  protect_from_forgery :except => ["receive_sms"]
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Goal Added! A text message has been sent to your phone!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end
  
  # Web "check in" link  ### TARGET 8/17/15
  def update
    @micropost = Micropost.find(params[:id])
    if @micropost.update_attributes(micropost_params)
      # Update button makes micropost's check_in_current == true
      @micropost.checking_in_number
      flash[:success] = "Checked In!"
      redirect_to root_url
    else
      redirect_to root_url
    end
  end


    # @micropost = Micropost.find(params[:id])
    # @micropost.good_check_in_tally
    # @micropost.send_day_completed_sms
    # @micropost.check_if_still_active
    # @user.micropost_id_due_now = nil if @user.micropost_id_due_now == @micropost.id # takes it off stage
    
    # # Find Micropost ID in it's queue and if found, deletes it
    # @user.microposts_due_queue #something.delete
    # @user.save

    # # Deletes any lateness delayed job associated with this micropost
    # garbage_jobs = Delayed::Job.where(:owner_type => "Micropost", :ower_job_type => "Micropost Two Hour Deadline", :owner_id => @micropost.id)
    # garbage_jobs.each do |job|
    #   job.delete
    # end


  def destroy
    # Destroys all associated jobs
    Delayed::Job.destroy_all(:owner_type => "Micropost", :owner_id => @micropost.id)
    
    # And the main object body
    @micropost.destroy
    flash[:success] = "Goal Deleted."
    redirect_to request.referrer || root_url
  end

  # Untested by RSPEC
  def receive_sms  #receives and parses SMS content from users
    @message_body = params["Body"]
    @from_number = params["From"]
    @db_friendly_num = @from_number.sub /[+]/, ''  # Plucks plus sign 
    @phone_owner = User.find_by(:phone_number => @db_friendly_num)

    if @message_body[/\d/] 
    # Checks each character in SMS against goals ID map from User's column
      processed_body = @message_body.split(",")
      processed_body.each do |c|
          id_int = c.to_i  # datatype stupidity
          @micropost = Micropost.find_by(:id => @phone_owner.current_tasks_map.find{|id| id["task"] == id_int }["micropost id"]) 
          @micropost.checking_in_number
          @micropost.send_day_completed_sms 
      end
    else 
      case @message_body
      when "YES", "Yes", "yes"
        @micropost = Micropost.find(@phone_owner.micropost_id_due_now)
        @micropost.good_check_in_tally
        @micropost.send_day_completed_sms
        @micropost.check_if_still_active
        @phone_owner.micropost_id_due_now = nil # takes it off stage
        @phone_owner.save 
      when "NO", "No", "no"
        @micropost = Micropost.find(@phone_owner.micropost_id_due_now)
        @micropost.bad_check_in_tally
        # @micropost.send_bad_news_to_recipients   ### Future implimentation
        @micropost.send_day_incomplete_sms
        @micropost.check_if_still_active
        @phone_owner.micropost_id_due_now = nil # takes it off stage
        @phone_owner.save 
      when "LIST", "List", "list" 
        @micropost = Micropost.find(@phone_owner.microposts.first)
        @micropost.send_user_status_sms
      end
    end
    render xml: "<Response/>"
  end

  private
    
    def micropost_params
      params.require(:micropost).permit(:title, :content, :picture, 
                                        :delayed_job_id, 
                                        :completed, :check_in_current, 
                                        :days_to_complete, :days_completed, 
                                        :days_remaining, :current_day,
                                        :late_but_current, :active)
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end




# _to_do.html.erb 

# August 18, 2015

<% if @active_goals.any? %>
  <%= javascript_include_tag "active_tasks" %>
  <table id="active_tasks_table">
    <thead>
        <tr>
          <th>Upcoming Deadlines</th>
        </tr>
    </thead>
    <tbody>
      <% @active_goals.each do |deadline| %>
          <tr>
            <!-- Rails Variables here -->
            <% deadline_owner = User.find_by(:id => deadline.user_id) %>

            <!-- Area of investigation 8/15/15 -->

            <% due_time = Delayed::Job.where(:user_id => current_user.id, :owner_type => "Micropost", :owner_id => deadline.id).order("created_at DESC").first.run_at %>
            <!-- set two states, one for 24 cycle and one for late cycle -->
            <% seconds_remaining = due_time - Time.now %>
            <% next_due_date = seconds_remaining + 24.hours %>

          <!-- ** Table Row begins ** -->

          <!-- Display this if CHECKED-IN on time, waiting for next 24 hour cycle. -->
          <% if deadline.check_in_current == true && deadline.days_remaining > 0 %>
            <td id="due_time"><%= distance_of_time(next_due_date, :except => :seconds) %></td>
            <td data-due="<%= next_due_date %>"><%= deadline.title %></td>

          <!-- Display this if NOT CHECKED-IN, is past due, and awaiting two hour last call response. -->
          <% elsif deadline.check_in_current == false && deadline_owner.stage_or_queue_occupied_by(deadline.id) %>
            <td id="due_time">PAST DUE</td>
            <td data-due="<%= seconds_remaining %>"><%= deadline.title %></td>

          <% else %>
            <!-- default clock. NOT CHECKED-IN or CHECKED-IN LATE -->
              <td id="due_time"><%= distance_of_time(seconds_remaining, :except => :seconds) %></td>
              <td data-due="<%= seconds_remaining %>"><%= deadline.title %></td>
          <% end %>

          <!-- CHECK IN BUTTON LOGIC -->
          <% if deadline.fresh_and_not_checked_in? %>

            <% if deadline_owner.stage_or_queue_occupied_by(deadline.id) %>
              <td><!-- check this in instantly -->
                <%= form_for(deadline) do |f| %>
                  <%= f.hidden_field :late_but_current, value: true %>
                  <%= f.submit 'Check In' %>
                <% end %>
              </td>
            <% else %>
              <td>
                <%= form_for(deadline) do |f| %>
                  <%= f.hidden_field :check_in_current, value: true %>
                  <%= f.submit 'Check In' %>
                <% end %>
              </td>
            <% end %> 

          <% else %>
            <td>
              Awaiting Next Check-In Period
            </td>
          <% end %>

          </tr>
      <% end %>
      </tbody>
  </table>
<% else %>
  <h3> Nothing due! Yay!</h3>
<% end %>

