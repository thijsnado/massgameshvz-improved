class UserSessionsController < ApplicationController
  before_filter :authenticate, :only => :destroy
  skip_filter :check_if_has_participation
  skip_before_filter :verify_authenticity_token #we use some web services here so authenticity token is not an option
  
  def new
    @from = params[:from]
    @user_session = UserSession.new
  end

  # user_sessions_controller.rb
  def create
    @user_session = UserSession.new(params[:user_session])
    @from = params[:from]
    respond_to do |format|
      if @user_session.save
        if @from
          format.html{ redirect_to @from }
        else
          format.html{ redirect_to root_url }
        end
        format.xml{ render :xml => @user_session.record }
      else
        logger.info 'Shit!'
        format.html{ render :action => 'new' }
        format.xml{ render :xml => @user_session.errors, :status => :unprocessable_entity}
      end
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