class AlbumsController < ApplicationController
  before_filter :load_album_owner
  before_filter :require_login, only: [:new, :create, :edit, :update, :destroy]

  # GET /user/:user_id/albums
  def index
    # The #to_a here avoids obscure problems with Draper and ActiveSupport::HashWithIndifferentAccess
    # resulting in an exception because someone tries to modify frozen hashes. That means that
    # {sth: @user.albums}.with_indifferent_access will not work.
    # Filed an issue here: https://github.com/jcasimir/draper/issues/158
    @albums = @user.albums.to_a
  end

  # GET /user/:user_id/albums/:id
  def show
    redirect_to controller: 'photos', action: 'index', album_id: params[:id] and return
  end

  # GET /user/:user_id/albums/new
  def new
    redirect_to root_path and return unless is_owner? @user.id
    @album = @user.albums.build
  end

  # GET /user/:user_id/albums/:id/edit
  def edit
    @album = Album.find(params[:id])
    redirect_to root_path and return unless is_owner? @album.user_id
  end

  # POST /user/:user_id/albums
  def create
    redirect_to root_path and return unless is_owner? @user.id
    @album = @user.albums.build(params[:album])

    if @album.save
      flash[:message] = t('albums.new.created')
      redirect_to controller: 'albums', action: 'index' and return
    else
      render :new and return
    end
  end

  # PUT /user/:user_id/albums/:id
  def update
    @album = Album.find(params[:id])
    redirect_to root_path and return unless is_owner? @album.user_id
    
    if @album.update_attributes(params[:album])
      flash[:message] = t('albums.edit.updated')
      redirect_to controller: 'photos', action: 'index', album_id: params[:id] and return
    else
      render :edit and return
    end
  end

  # DELETE /user/:user_id/albums/:id
  def destroy
    @album = Album.find(params[:id])
    redirect_to root_path and return unless is_owner? @album.user_id
    
    @album.destroy

    redirect_to user_albums_url(@user) and return
  end

  private

  def load_album_owner
    @user = UserDecorator.find(params[:user_id])
  end
end
