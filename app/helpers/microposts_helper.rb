module MicropostsHelper
  # Checks a micropost for at least one recipient
  def recipients_present?(micropost)
    if @micropost.recipients.first = nil
      return false
    else
      return true
    end
  end


end
