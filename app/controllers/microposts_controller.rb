class MicropostsController < ApplicationController
  #skip_before_filter :force_ssl # check later if needed
  protect_from_forgery :except => ["receive_sms"]
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Goal Added! A Text Will Be Sent In 24 Hours!"
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
    @micropost = Micropost.find(@message_body)  # Looks for corresponding ID

    # If it detects ID number, marks micropost as Complete
  
    @micropost.check_in_current = true  

    @micropost.save
    #render xml: "<Response/>"
    render xml: "<Response>
                    <Message>Thank you for checking into your goal!</Message>
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
