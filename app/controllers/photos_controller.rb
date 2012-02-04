class PhotosController < ApplicationController
  before_filter :load_album, :load_album_owner
  before_filter :require_login, :only => [:new, :create, :edit, :update, :destroy]
    
  # GET /albums/:album_id/photos
  def index
    @photos = @album.photos
  end

  # GET /albums/:album_id/photos/:id
  def show
    @photo = @album.photos.find(params[:id])
  end

  # GET /albums/:album_id/photos/new
  def new
    require_album_ownership
    @photo = @album.photos.build
  end

  # GET /albums/:album_id/photos/:id/edit
  def edit
    require_album_ownership
    @photo = @album.photos.find(params[:id])
  end

  # POST /albums/:album_id/photos
  def create
    require_album_ownership
    @photo = @album.photos.build(params[:photo])

    if @photo.save
      flash[:message] = I18n.t('views.photo.created')
      redirect_to [@album, @photo]
    else
      render action: "new"
    end
  end

  # PUT /albums/:album_id/photos/:id
  def update
    require_album_ownership
    @photo = @album.photos.find(params[:id])

    if @photo.update_attributes(params[:photo])
      flash[:message] = I18n.t('views.photo.updated')
      redirect_to [@album, @photo]
    else
      render action: "edit"
    end
  end

  # DELETE /albums/:album_id/photos/1
  def destroy
    require_album_ownership
    @photo = @album.photos.find(params[:id])    
    
    @photo.destroy

    redirect_to album_photos_url(@album)
  end
  
  private
  
  def load_album
    @album = Album.find(params[:album_id])
  end
  
  def load_album_owner
    @user = User.find(@album.user_id)
  end
end
