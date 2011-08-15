class UserSessionsController < ApplicationController
  before_filter :authenticate, :only => :destroy
  skip_filter :check_if_has_participation
  
  def new
    @from = params[:from]
    @user_session = UserSession.new
  end

  # user_sessions_controller.rb
  def create
    @user_session = UserSession.new(params[:user_session])
    @from = params[:from]
    if @user_session.save
      if @from
        redirect_to @from
      else
        redirect_to root_url
      end
    else
      logger.info 'Shit!'
      render :action => 'new'
    end
  end


  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    reset_session
    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end


end