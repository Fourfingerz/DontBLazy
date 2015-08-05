class StaticPagesController < ApplicationController
  
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @active_goals = current_user.microposts.where(:active => true)
      @deadlines = Delayed::Job.where
      if no_valid_phone?
        @user = current_user
      end
    end
  end

  def help
  end

  def about
  end
  
  def contact
  end
end
