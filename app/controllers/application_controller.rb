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
      flash[:error] = I18n.t('views.mustbeloged_error')
      redirect_to root_path
    end
  end
  
  def require_user_ownership
    unless current_user && current_user.id == @user.id
      flash[:error] = I18n.t('views.mustbeyours_error')
      redirect_to root_path
    end
  end
  
  def require_album_ownership
    unless current_user && current_user.id == @album.user_id
      flash[:error] = I18n.t('views.mustbeyours_error')
      redirect_to root_path
    end
  end
  
  def require_comment_ownership
    unless current_user && current_user.id == @comment.user_id
      flash[:error] = I18n.t('views.mustbeyours_error')
      redirect_to root_path
    end
  end
  
  def has_album_rights?
    (current_user && @album.user_id == current_user.id) ? true : false
  end
  
  def has_user_riths?
    (current_user && @user.id == current_user.id) ? true : false
  end
end
