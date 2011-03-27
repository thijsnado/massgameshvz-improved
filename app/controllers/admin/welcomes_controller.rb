class Admin::WelcomesController < AdminController
  
  before_filter :get_welcome_page, :except => :update
  
  def show
  end
  
  def create
    Welcome.contents = params[:content] 
    redirect_to :action => :show
  end
  
  def get_welcome_page
    @welcome_page = Welcome.contents
  end

end