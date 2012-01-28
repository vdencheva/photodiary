module ApplicationHelper
  def logged_in?
    session[:current_user] ? true : false
  end
end
