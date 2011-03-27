class WelcomeController < ApplicationController
  
  def index
    @welcome_page = Welcome.contents
  end

end
