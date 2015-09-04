class StaticPagesController < ApplicationController
  
  def home  # Serves as staging for builds (ex: def new)
    if logged_in?
      @micropost = current_user.microposts.build
      @recipient = current_user.recipients.build
      @micropost_recipients = @micropost.recipients.build  # accountability buddies 
      @feed_items = current_user.feed.paginate(page: params[:page])
      @active_goals = current_user.microposts.where(:active => true)
      if no_valid_phone?
        @user = current_user
      end
    end
  end

  def comments
    @micropost = Micropost.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def help
  end

  def about
  end
  
  def contact
  end
end
