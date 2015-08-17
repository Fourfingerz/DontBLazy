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
  
  def update
    @micropost = Micropost.find(params[:id])
    if @micropost.update_attributes(micropost_params)
      @micropost.days_completed += 1
      @micropost.day_already_completed = true
      @micropost.active = false if @micropost.current_day == @micropost.days_to_complete
      @micropost.save
      flash[:success] = "Checked In!"
      redirect_to root_url
    else
      redirect_to root_url
    end
  end

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
