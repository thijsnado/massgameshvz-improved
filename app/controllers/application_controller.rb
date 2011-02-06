class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :current_user
  before_filter :playable
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def authenticate
    if @current_user
      return
    else
      redirect_to login_url(:from => request.request_uri)
    end
  end
  
  def playable
    @playable||=Game.current
  end
end
