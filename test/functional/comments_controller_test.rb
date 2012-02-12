require 'test_helper'

class CommentsControllerTest < ActionController::TestCase  
  setup do
    @comment = comments(:one)
    @photo = @comment.photo
    @album = @photo.album
    @user = @comment.user
  end
  
  teardown do
    session[:current_user] = nil
    @current_user = nil
  end

  test "should create comment when loged in" do
    login_as @user
    assert_difference('Comment.count') do
      post :create, album_id: @album.id, photo_id: @photo.id, comment: { body: 'test comment' }
    end

    assert_redirected_to album_photo_path(@album, @photo)
    assert_equal I18n.t('views.comment.created'), flash[:message]
  end
  
  test "should not create comment when not loged in" do
    assert_difference('Comment.count', 0) do
      post :create, album_id: @album.id, photo_id: @photo.id, comment: { body: 'test comment' }
    end

    access_denied_mustlogin
  end
  
  test "should get edit when loged in" do
    login_as @user
    get :edit, album_id: @album.id, photo_id: @photo.id, id: @comment.id
    assert_response :success
    assert_not_nil assigns(:comment)
  end
  
  test "should not get edit when loged in as another user" do
    login_as users(:two)
    get :edit, album_id: @album.id, photo_id: @photo.id, id: @comment.id
    access_denied_notallowed
  end
  
  test "should not get edit when not loged in" do
    get :edit, album_id: @album.id, photo_id: @photo.id, id: @comment.id
    access_denied_mustlogin
  end
  
  test "should update comment when loged in" do
    login_as @user
    put :update, album_id: @album.id, photo_id: @photo.id, id: @comment.to_param, comment: @comment.attributes
    assert_redirected_to album_photo_path(@album, @photo)
    assert_equal I18n.t('views.comment.updated'), flash[:message]
  end
  
  test "should not update comment when loged in as another user" do
    login_as users(:two)
    put :update, album_id: @album.id, photo_id: @photo.id, id: @comment.to_param, comment: @comment.attributes
    access_denied_notallowed
  end
  
  test "should not update comment when not loged in" do
    put :update, album_id: @album.id, photo_id: @photo.id, id: @comment.to_param, comment: @comment.attributes
    access_denied_mustlogin
  end
  
end
