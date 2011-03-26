class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :current_user
  before_filter :playable
  before_filter :signupable
  
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
  
  def current_game
    @current_game||=Game.current
  end
  
  def playable
    @playable = false
    if current_game && Time.now.between?(current_game.start_at, current_game.end_at)
      if current_user && current_user.current_participation
        @playable = true
      end
    end
    return @playable
  end
  
  def signupable
    if current_game && Time.now.between?(current_game.signup_start_at, current_game.signup_end_at)
      @signupable = true
    else
      @signupable = false
    end
    return @signupable
  end
  
  def must_be_playable
    if playable
      return
    else
      redirect_to root_url
    end
  end
  
  def must_be_signupable
    if signupable
      return true
    else
      redirect_to root_url
    end
  end
  
  def must_be_zombie
    return true if current_user && current_user.current_participation && current_user.current_participation.zombie?
    redirect_to root_url
  end
  
  def must_be_human
    return true if current_user && current_user.current_participation && current_user.current_participation.human?
    redirect_to root_url
  end
  
  def must_be_vaccinatable
    if must_be_zombie
      current_user.current_participation.vaccinatable?
    end
  end
end
