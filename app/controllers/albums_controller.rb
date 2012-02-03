class AlbumsController < ApplicationController
  helper_method :has_edit_right?
  
  before_filter :require_login, :only => [:new, :create, :edit, :update, :destroy]
  
  # GET /user/:user_id/albums
  def index
    @album_user = User.find(params[:user_id])
    @albums = @album_user.albums
  end

  # GET /user/:user_id/albums/:id
  def show
    @album = Album.find(params[:id])
    load_album_owner
  end

  # GET /user/:user_id/albums/new
  def new
    @album = current_user.albums.build
  end

  # GET /user/:user_id/albums/:id/edit
  def edit
    @album = Album.find(params[:id])
    require_album_ownership
  end

  # POST /user/:user_id/albums
  def create
    @album = current_user.albums.build(params[:album])

    if @album.save
      redirect_to [current_user, @album], notice: 'Album was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /user/:user_id/albums/:id
  def update
    @album = Album.find(params[:id])
    require_album_ownership
    
    if @album.update_attributes(params[:album])
      redirect_to [current_user, @album], notice: 'Album was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /user/:user_id/albums/:id
  def destroy
    @album = Album.find(params[:id])
    require_album_ownership
    
    @album.destroy

    redirect_to user_albums_url(current_user)
  end
  
  private
  
  def load_album_owner
    @album_user = User.find(@album.user_id)
  end
  
  def has_edit_right?
    @album_user.id == current_user.id ? true : false
  end
end
