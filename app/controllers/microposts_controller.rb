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
        if c == "1"  # Looks for corresponding ID from SMS body
          @micropost = Micropost.find(@phone_owner.current_tasks_map.find{|id| id["1"]}["1"])
            @micropost.check_in_current = true  # If it detects ID number, marks micropost as Complete
            @micropost.save
        elsif c == "2"
          @micropost = Micropost.find(@phone_owner.current_tasks_map.find{|id| id["2"]}["2"])
            @micropost.check_in_current = true  
            @micropost.save
        elsif c == "3"
          @micropost = Micropost.find(@phone_owner.current_tasks_map.find{|id| id["3"]}["3"])
            @micropost.check_in_current = true  
            @micropost.save
        elsif c == "4"
          @micropost = Micropost.find(@phone_owner.current_tasks_map.find{|id| id["4"]}["4"])
            @micropost.check_in_current = true  
            @micropost.save
        elsif c == "5" 
          @micropost = Micropost.find(@phone_owner.current_tasks_map.find{|id| id["5"]}["5"])
            @micropost.check_in_current = true  
            @micropost.save
        end
      end
    else 
      @micropost = Micropost.find(@phone_owner.micropost_id_due_now)
      if @message_body.include? "YES" or "Yes" or "yes"
        @micropost.good_check_in_tally
        @micropost.send_day_completed_sms
        @phone_owner.micropost_id_due_now = nil 
        @phone_owner.save 
      elsif @message_body.include? "NO" or "No" or "no"
        @micropost.bad_check_in_tally
        @phone_owner.micropost_id_due_now = nil
        @phone_owner.save  
      elsif @message_body.include? "LIST" or "List" or "list"
        @phone_owner.send_status_SMS
      else
        @micropost.send_bad_entry_sms
      end   
    end
  end

  private
    
    def micropost_params
      params.require(:micropost).permit(:title, :content, :picture, 
                                        :delayed_job_id, 
                                        :completed, :check_in_current, 
                                        :days_to_complete, :days_completed, 
                                        :days_remaining, :current_day)
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
