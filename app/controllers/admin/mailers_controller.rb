class Admin::MailersController < AdminController
  def show
    @email_addresses = Game.current.game_participations.includes(:user).map{|gp| gp.user.email_address rescue nil} rescue []
  end
end
