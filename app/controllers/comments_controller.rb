class CommentsController < ApplicationController
  before_filter :require_login, only: [:create, :edit, :update]
  
  # POST /albums/:album_id/photo/:photo_id/comments
  def create
    @photo = Photo.find params[:photo_id]
    @comment = @photo.comments.build params[:comment]
    @comment.user = current_user

    if @comment.save
      flash[:message] = t('comments.new.created')
      redirect_to controller: 'photos', action: 'show', album_id: @photo.album_id, id: @photo.id
    else
      render :new
    end
  end
  
  # GET /albums/:album_id/photos/:photo_id/comments/:id/edit
  def edit
    load_comment_and_photo
    redirect_to root_path and return unless is_owner? @comment.user_id
  end

  # PUT /albums/:album_id/photos/:photo_id/comments/:id
  def update
    load_comment_and_photo
    redirect_to root_path and return unless is_owner? @comment.user_id

    if @comment.update_attributes params[:comment]
      flash[:message] = t('comments.edit.updated')
      redirect_to controller: 'photos', action: 'show', album_id: @photo.album_id, id: @photo.id and return
    else
      render :edit and return
    end
  end
  
  private
  
  def load_comment_and_photo
    @comment = Comment.find params[:id]
    @photo = @comment.photo
  end
end
