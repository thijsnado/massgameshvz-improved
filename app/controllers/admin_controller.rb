class AdminController < ApplicationController
  before_filter :must_be_admin

  def index
  end

  def must_be_admin
    return if current_user && current_user.is_admin?
    redirect_to root_url
  end

end
