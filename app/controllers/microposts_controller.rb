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

  def receive_sms  #receives and parses SMS content from users
    @message_body = params["Body"]
    @from_number = params["From"]
    @db_friendly_num = @from_number.sub /[+]/, ''
    @phone_owner = User.find_by(:phone_number => @db_friendly_num)

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

    render xml: "<Response>
                    <Message>You just checked into your goals. Thank you!</Message>
                </Response>"
  end

  private
    
    def micropost_params
      params.require(:micropost).permit(:title, :content, :picture, :schedule_time)
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
