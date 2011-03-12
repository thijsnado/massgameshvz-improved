class Admin::MailersController < AdminController
  def show
  end
  
  def sender
    message = Message.create :body => params[:message]
    call_rake :send_mailing, :message => message.id
  end
end
