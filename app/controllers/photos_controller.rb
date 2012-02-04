class PhotosController < ApplicationController
  before_filter :require_login, :only => [:new, :create, :edit, :update, :destroy]
  
  # GET /albums/:album_id/photos
  def index
    @photo_album = Album.find(params[:album_id])
    @photos = @photo_album.photos
  end

  # GET /albums/:album_id/photos/:id
  def show
    @photo = Photo.find(params[:id])
    @photo_album = Album.find(@photo.album_id)
  end

  # GET /albums/:album_id/photos/new
  def new
    @photo_album = Album.find(params[:album_id])
    @photo = @photo_album.photos.build
  end

  # GET /albums/:album_id/photos/:id/edit
  def edit
    # проверявам че този албум е на current_user и тази снимка е в него?
    @photo = Photo.find(params[:id])
    @photo_album = Album.find(@photo.album_id)
  end

  # POST /albums/:album_id/photos
  def create
    # проверявам че този албум е на current_user
    @photo_album = Album.find(params[:album_id])
    @photo = @photo_album.photos.build(params[:photo])

    if @photo.save
      redirect_to [@photo_album, @photo], notice: 'Photo was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /albums/:album_id/photos/:id
  def update
    # проверявам че този албум е на current_user и тази снимка е в него?
    @photo = Photo.find(params[:id])
    @photo_album = Album.find(@photo.album_id)

    if @photo.update_attributes(params[:photo])
      redirect_to [@photo_album, @photo], notice: 'Photo was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /albums/:album_id/photos/1
  def destroy
    # проверявам че този албум е на current_user
    @photo = Photo.find(params[:id])
    @photo_album = Album.find(@photo.album_id)

    redirect_to album_photos_url(@photo_album)
  end
end
