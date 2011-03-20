class VaccinesController < ApplicationController
  
  def enter
    @vaccine = Vaccine.new
  end
  
  def take
    @vaccine = Vaccine.find_by_code(params[:vaccine][:code])
    if @vaccine && @vaccine.take(@current_user.current_participation)
      flash[:notice] = 'You are no longer a zombie'
      redirect_to root_url
    else
      flash[:notice] = 'Not a valid vaccine code'
      redirect_to enter_vaccines_url
    end
  end
  
end