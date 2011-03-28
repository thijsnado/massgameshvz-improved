class ConfirmationEmail < ActionMailer::Base
  default :from => "noreply@hvz.massgamesrso.org"
  
  def confirmation_message(user)
    recipients user.email_address
    subject "hvz confirmation"
    sent_on Time.now
    content_type "text/html"
    from "noreply@hvz.massgamesrso.org"
    @user = user
    @confirmation_hash = user.confirmation_hash
  end
end
