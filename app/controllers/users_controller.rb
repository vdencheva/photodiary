class UsersController < ApplicationController  
  before_filter :require_login, only: [:edit, :update, :destroy, :logout]
  
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
    redirect_to root_path and return unless is_owner? @user.id
  end

  # POST /users
  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:message] = t('users.new.created')
      redirect_to @user and return
    else
       render :new and return
    end
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])
    redirect_to root_path and return unless is_owner? @user.id
    
    if params[:user][:photo]
      params[:user][:remove_photo] = nil
    end

    if @user.update_attributes(params[:user])
      flash[:message] = t('users.edit.updated')
      redirect_to @user and return
    else
      render :edit and return
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    redirect_to root_path and return unless is_owner? @user.id
    
    @user.destroy

    redirect_to users_path and return
  end
  
  # GET /login
  def login
    @user = User.new
  end
  
  # POST /login
  def login_process
    session[:current_user] = User.authenticate(params[:user][:username], params[:user][:password])
    if session[:current_user]
      flash[:message] = t('users.login.succeeded')
      redirect_to root_path and return
    else
      flash.now[:error] = t('users.login.error')
      @user = User.new
      render :login and return
    end
  end
  
  # DELETE /logout
  def logout
    reset_session
    flash[:message] = t('users.logout.succeeded')
    redirect_to root_path and return
  end
end
