module MicropostsHelper

  # Logs in a user
  def login_user
    before(:each) do
      user = create(:user)
      content = create(:micropost_with_recipients)
      sign_in user, 
    end
  end

  # Checks a micropost for at least one recipient
  def recipients_present?(micropost)
    if @micropost.recipients = nil
      return false
    else
      return true
    end
  end


end
