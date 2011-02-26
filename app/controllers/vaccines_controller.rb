class VaccinesController < ApplicationController
  
  def enter
    @vaccine = Vaccine.new
  end
  
  def take
    @vaccine = Vaccine.find_by_code(params[:vaccine][:code])
    if @vaccine.take(@current_user.current_participation)
      redirect_to root_url
    else
      redirect_to enter_vaccines_url
    end
  end
  
end