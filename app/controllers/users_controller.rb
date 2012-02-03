class UsersController < ApplicationController
  helper_method :has_edit_right?
  
  before_filter :require_login, :only => [:edit, :update, :destroy, :logout]
  
  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    require_user_ownership
  end

  # POST /users
  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to @user, notice: I18n.t('views.user.created')
    else
       render action: "new"
    end
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])
    require_user_ownership
    
    if params[:user][:photo]
      params[:user][:remove_photo] = nil
    end

    if @user.update_attributes(params[:user])
      redirect_to @user, notice: I18n.t('views.user.updated')
    else
      render action: "edit"
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    require_user_ownership
    
    @user.destroy

    redirect_to users_url
  end
  
  # GET /login
  def login
    @user = User.new
  end
  
  # POST /login
  def login_process
    session[:current_user] = User.authenticate(params[:user][:username], params[:user][:password])
    if session[:current_user]
      flash[:message] = I18n.t('views.user.login_succeeded')
      redirect_to root_path
    else
      flash.now[:error] = I18n.t('views.user.login_error')
      @user = User.new
      render action: "login"
    end
  end
  
  # DELETE /logout
  def logout
    if session[:current_user]
      reset_session
      flash[:message] = I18n.t('views.user.logout_succeeded')
    else
      flash[:error] = I18n.t('views.user.logout_error')
    end
    redirect_to root_path
  end
  
   private
  
  def has_edit_right?
    @user.id == current_user.id ? true : false
  end
end
