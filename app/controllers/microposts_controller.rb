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
  
  def destroy
    @micropost.destroy
    flash[:success] = "Goal Abandoned."
    redirect_to request.referrer || root_url
  end

  # Untested by RSPEC
  def receive_sms  #receives and parses SMS content from users
    @message_body = params["Body"]
    @from_number = params["From"]
    @db_friendly_num = @from_number.sub /[+]/, ''  # Plucks plus sign 
    @phone_owner = User.find_by(:phone_number => @db_friendly_num)

    if @message_body =~ /\d/ 
    # CURRENT SUPPORT: SINGLE DIGITS ONLY
    # Checks each character in SMS against goals ID map from User's column
      @message_body.each_char do |c|
        if c =~ /\d/
          number_as_int = c.to_i
          @micropost = Micropost.find(@phone_owner.current_tasks_map.find{|id| id["task"] == number_as_int }["micropost id"]) 
          @micropost.checking_in_number(c)
        end  
      end

    else 

      if @message_body.include? "YES" or "Yes" or "yes"
        @micropost = Micropost.find(@phone_owner.micropost_id_due_now)
        @micropost.good_check_in_tally
        @micropost.send_day_completed_sms
        @micropost.check_if_still_active
        @phone_owner.micropost_id_due_now = nil # takes it off stage
        @phone_owner.save 

      elsif @message_body.include? "NO" or "No" or "no"
        @micropost = Micropost.find(@phone_owner.micropost_id_due_now)
        @micropost.bad_check_in_tally
        # @micropost.send_bad_news_to_recipients   ### Future implimentation
        @micropost.send_day_incomplete_sms
        @micropost.check_if_still_active
        @phone_owner.micropost_id_due_now = nil
        @phone_owner.save 

      elsif @message_body.include? "LIST" or "List" or "list" # GLITCHED, sends check_in_complete_sms wrongly
        @micropost = Micropost.find(@phone_owner.microposts.first)
        @phone_owner.send_status_SMS

      else
        @phone_owner.send_bad_entry_sms(@from_number)  # move these to user
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