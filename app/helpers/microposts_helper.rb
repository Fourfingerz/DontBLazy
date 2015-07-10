module MicropostsHelper
  # Checks a micropost for at least one recipient
  def recipients_present?(micropost)
    if micropost.recipient = nil
      return false
    else
      return true
    end
  end


end
