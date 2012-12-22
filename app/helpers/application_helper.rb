module ApplicationHelper
  
  def profile_url
    url_for(@current_user)
  end
end
