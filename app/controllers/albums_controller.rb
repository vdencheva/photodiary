class AlbumsController < ApplicationController
  before_filter :load_album_owner
  before_filter :require_login, :only => [:new, :create, :edit, :update, :destroy]
  
  # GET /user/:user_id/albums
  def index
    @albums = @user.albums
  end

  # GET /user/:user_id/albums/:id
  def show
    redirect_to :controller => 'photos', :action => 'index', :album_id => params[:id]
  end

  # GET /user/:user_id/albums/new
  def new
    require_user_ownership
    @album = @user.albums.build
  end

  # GET /user/:user_id/albums/:id/edit
  def edit
    @album = Album.find(params[:id])
    require_album_ownership
  end

  # POST /user/:user_id/albums
  def create
    require_user_ownership
    @album = @user.albums.build(params[:album])

    if @album.save
      flash[:message] = I18n.t('views.album.created')
      redirect_to :controller => 'albums', :action => 'index'
    else
      render :new
    end
  end

  # PUT /user/:user_id/albums/:id
  def update
    @album = Album.find(params[:id])
    require_album_ownership
    
    if @album.update_attributes(params[:album])
      flash[:message] = I18n.t('views.album.updated')
      redirect_to :controller => 'photos', :action => 'index', :album_id => params[:id]
    else
      render :edit
    end
  end

  # DELETE /user/:user_id/albums/:id
  def destroy
    @album = Album.find(params[:id])
    require_album_ownership
    
    @album.destroy

    redirect_to user_albums_url(@user)
  end
  
  private
  
  def load_album_owner
    @user = User.find(params[:user_id])
  end
end
