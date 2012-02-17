class ApplicationController < ActionController::Base
  before_filter :load_current_user
  
  helper_method :current_user, :has_album_rights?, :has_user_riths?, :logged_in?
  
  protect_from_forgery
  
  private
  
  def logged_in?
    session[:current_user] ? true : false
  end
  
  def load_current_user
    if logged_in?
      @current_user = User.find(session[:current_user])
    else
      nil
    end
  end
  
  def current_user
    @current_user ? @current_user : nil
  end
  
  def require_login
    unless logged_in?
      flash[:error] = t('mustbeloged_error')
      redirect_to root_path
    end
  end
  
  def is_owner?(owner_id)
    if current_user && current_user.id == owner_id
      true
    else
      flash[:error] = t('mustbeyours_error')
      false
    end
  end
  
  def has_album_rights?
    current_user && @album.user_id == current_user.id
  end
  
  def has_user_riths?
    current_user && @user.id == current_user.id
  end
end
