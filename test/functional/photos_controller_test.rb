require 'test_helper'

class PhotosControllerTest < ActionController::TestCase  
  setup do
    @photo = photos(:one)
    @album = @photo.album
    @user = @album.user
  end
  
  teardown do
    session[:current_user] = nil
    @current_user = nil
  end
  
  test "should get index" do
    get :index, album_id: @album.id
    assert_response :success
    assert_not_nil assigns(:photos)
  end

  test "should get new when loged in" do
    login_as @user
    get :new, album_id: @album.id
    assert_response :success
  end
  
  test "should not get new when loged in as another user" do
    login_as users(:two)
    get :new, album_id: @album.id
    access_denied_notallowed
  end
  
  test "should not get new when not loged in" do
    get :new, album_id: @album.id
    access_denied_mustlogin
  end

  test "should create photo when loged in" do
    login_as @user
    assert_difference('Photo.count') do
      post :create, album_id: @album.id, photo: { file: fixture_file_upload('DSC_5729.jpg', 'image/jpeg', :binary) }
    end

    assert_redirected_to album_photo_path(@album, assigns(:photo))
    assert_equal I18n.t('views.photo.created'), flash[:message]
  end
  
  test "should not create photo when loged in as another user" do
    login_as users(:two)
    assert_difference('Photo.count', 0) do
      post :create, album_id: @album.id, photo: { file: fixture_file_upload('DSC_5729.jpg', 'image/jpeg', :binary) }
    end

    access_denied_notallowed
  end
  
  test "should not create photo when not loged in" do
    assert_difference('Photo.count', 0) do
      post :create, album_id: @album.id, photo: { file: fixture_file_upload('DSC_5729.jpg', 'image/jpeg', :binary) }
    end

    access_denied_mustlogin
  end

  test "should show photo" do
    get :show, album_id: @album.id, id: @photo.to_param
    assert_response :success
    assert_not_nil assigns(:photo)
  end

  test "should get edit when loged in" do
    login_as @user
    get :edit, album_id: @album.id, id: @photo.to_param
    assert_response :success
    assert_not_nil assigns(:photo)
  end
  
  test "should not get edit when loged in as another user" do
    login_as users(:two)
    get :edit, album_id: @album.id, id: @photo.to_param
    access_denied_notallowed
  end
  
  test "should not get edit when not loged in" do
    get :edit, album_id: @album.id, id: @photo.to_param
    access_denied_mustlogin
  end
  
  test "should update photo when loged in" do
    login_as @user
    put :update, album_id: @album.id, id: @photo.to_param, photo: @photo.attributes
    assert_redirected_to album_photo_path(@album, assigns(:photo))
    assert_equal I18n.t('views.photo.updated'), flash[:message]
  end
  
  test "should not update photo when loged in as another user" do
    login_as users(:two)
    put :update, album_id: @album.id, id: @photo.to_param, photo: @photo.attributes
    access_denied_notallowed
  end
  
  test "should not update photo when not loged in" do
    put :update, album_id: @album.id, id: @photo.to_param, photo: @photo.attributes
    access_denied_mustlogin
  end
  
  test "should destroy photo when loged in" do
    login_as @user
    assert_difference('Photo.count', -1) do
      delete :destroy, album_id: @album.id, id: @photo.to_param
    end

    assert_redirected_to album_photos_path(@album)
  end
  
  test "should not destroy photo when loged in as another user" do
    login_as users(:two)
    assert_difference('Photo.count', 0) do
      delete :destroy, album_id: @album.id, id: @photo.to_param
    end

    access_denied_notallowed
  end
  
  test "should not destroy photo when not loged in" do
    assert_difference('Photo.count', 0) do
      delete :destroy, album_id: @album.id, id: @photo.to_param
    end

    access_denied_mustlogin
  end
end
