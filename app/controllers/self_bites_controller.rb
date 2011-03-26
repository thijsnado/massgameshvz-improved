class SelfBitesController < ApplicationController
  before_filter :must_be_human

  def index
    @sarcastic_comment = SarcasticComment.random.description
  end
  
  def create
    @current_user.current_participation.self_bite
    flash[:notice] = 'you bit yourself!'
    redirect_to root_url
  end
end