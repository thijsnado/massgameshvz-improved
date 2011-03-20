class BitesController < ApplicationController
  
  before_filter :must_be_playable
  
  def report
    @bite_event = BiteEvent.new
  end
  
  def create
    code = params[:bite_event][:code]
    success = @current_user.current_participation.enter_user_number code
    if success
      flash[:notice] = "you bit somebody!"
      redirect_to root_url
    else
      flash[:notice] = "invalid bite code!"
      redirect_to report_new_bite_url
    end
  end
end