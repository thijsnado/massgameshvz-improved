class WelcomeController < ApplicationController
  
  def index
    @posts = Post.order('created_at desc')
    
    respond_to do |format|
      format.html #index.html.erb
      format.atom #index.atom.builder
    end
  end

end
