class VaccinesController < ApplicationController
  before_filter :must_be_playable
  before_filter :must_be_vaccinatable
  
  def enter
    @vaccine = Vaccine.new
  end
  
  def take
    @vaccine = Vaccine.find_by_code(Codeinator.format_code(params[:vaccine][:code]))
    if @vaccine && @vaccine.take(@current_user.current_participation)
      flash[:notice] = 'You are no longer a zombie. Please go to your profile page to get your new user number.'
      redirect_to root_url
    else
      flash[:notice] = 'Not a valid vaccine code'
      redirect_to enter_vaccines_url
    end
  end
  
end