class AlbumsController < ApplicationController
  before_filter :load_current_user
  
  # GET /albums
  def index
    @albums = @current_user.albums
  end

  # GET /albums/1
  def show
    @album = @current_user.albums.find(params[:id])
  end

  # GET /albums/new
  def new
    @album = @current_user.albums.build
  end

  # GET /albums/1/edit
  def edit
    @album = @current_user.albums.find(params[:id])
  end

  # POST /albums
  def create
    @album = @current_user.albums.build(params[:album])

    if @album.save
      redirect_to [@current_user, @album], notice: 'Album was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /albums/1
  def update
    @album = @current_user.albums.find(params[:id])

    if @album.update_attributes(params[:album])
      redirect_to [@current_user, @album], notice: 'Album was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /albums/1
  def destroy
    @album = @current_user.albums.find(params[:id])
    @album.destroy

    redirect_to user_albums_url(@current_user)
  end
  
  private

  def load_current_user
    if session[:current_user]
      @current_user = User.find session[:current_user][:id]
    else
      nil
    end
  end
end
