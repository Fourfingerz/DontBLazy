class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email  # Replace this with text verification
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def recipients
    @title = "Recipients"
    @user  = User.find(params[:id])
    @recipients = @user.recipients.paginate(page: params[:page])
    render 'show_recipient'
  end

  # DBL Phone Verification

  def add_phone
    @user = current_user
    @user.update_attributes(user_params)
    @user.generate_pin
    @user.send_pin
    respond_to do |format|
      format.js # render app/views/users/_add_phone.html.erb
    end
  end

  def verify
    @user = User.find_by(phone_number: params[:hidden_phone_number])
    @user.verify(params[:phone_pin])
    respond_to do |format|
        format.js
    end
  end
  
  private
    
    def user_params
      params.require(:user).permit(:name, :last_name, :email, 
                                   :password, :password_confirmation,
                                   :phone_number, :phone_pin, :phone_verified,
                                   :current_tasks_map)
    end
    
    # Before filters
    
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
