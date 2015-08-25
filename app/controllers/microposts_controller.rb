class MicropostsController < ApplicationController
  respond_to :html, :json
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

  def show
  end

  # Web "check in" link 
  def update
    @micropost = Micropost.find(params[:id])
    check_in_status = @micropost.check_in_current  # Old state
    if @micropost.update_attributes(micropost_params) 
      if !@micropost.check_in_current == check_in_status # if doesn't match old state, user clicked Check-IN button 
        @micropost.checking_in_number
        flash[:success] = "Checked In."
        redirect_to root_url
      else
        respond_to do |format|
          format.json { respond_with_bip(@micropost) }
          redirect_to root_url
        end
      end
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
        @micropost.send_day_completed_sms 
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
                                        :late_but_current, :active,
                                        micropost_recipient_attributes: [:recipient_id] )
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
