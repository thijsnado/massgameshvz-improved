class BitesController < ApplicationController
  
  before_filter :must_be_playable
  
  def report
    @bite_event = BiteEvent.new
  end
  
  def create
    code = params[:bite_event][:code]
    zombie = @current_user.current_participation.zombie?
    success = @current_user.current_participation.enter_user_number code
    if success
      flash[:notice] = zombie ? "you bit somebody!" : "somebody bit you!"
      redirect_to root_url
    else
      flash[:notice] = "invalid bite code!"
      redirect_to report_new_bite_url
    end
  end
end