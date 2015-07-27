class StaticPagesController < ApplicationController
  
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @deadlines = current_user.microposts.order(days_to_complete: :desc)
      # @deadlines = current_user.find_all_by_owner_type("Microposts")
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
