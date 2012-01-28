class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: I18n.t('views.user.created') }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: I18n.t('views.user.updated') }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end
  
  # GET /login
  def login
    @user = User.new
    
    respond_to do |format|
      format.html # login.html.erb
    end
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
      respond_to do |format|
        format.html { render action: "login" }
      end
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
end
