require 'test_helper'

class AlbumsControllerTest < ActionController::TestCase  
  setup do
    @album = albums(:one)
    @user = @album.user
  end
  
  teardown do
    session[:current_user] = nil
    @current_user = nil
  end
  
  test "should get index" do
    get :index, user_id: @user.id
    assert_response :success
    assert_not_nil assigns(:albums)
  end

  test "should get new when loged in" do
    login_as @user
    get :new, user_id: @user.id
    assert_response :success
  end
  
  test "should not get new when loged in as another user" do
    login_as users(:two)
    get :new, user_id: @user.id
    access_denied_notallowed
  end
  
  test "should not get new when not loged in" do
    get :new, user_id: @user.id
    access_denied_mustlogin
  end
  
  test "should create album when loged in" do
    login_as @user
    assert_difference('Album.count') do
      post :create, user_id: @user.id, album: { title: 'testtitle1', description: 'testdescr' }
    end

    assert_redirected_to user_albums_path(@user)
    assert_equal I18n.t('albums.new.created'), flash[:message]
  end
  
  test "should not create album when loged in as another user" do
    login_as users(:two)
    assert_difference('Album.count', 0) do
      post :create, user_id: @user.id, album: { title: 'testtitle2', description: 'testdescr' }
    end
    
    access_denied_notallowed
  end
  
  test "should not create album when not loged in" do
    assert_difference('Album.count', 0) do
      post :create, user_id: @user.id, album: { title: 'testtitle3', description: 'testdescr' }
    end
    
    access_denied_mustlogin
  end

  test "should show album" do
    get :show, user_id: @user.id, id: @album.to_param
    assert_redirected_to album_photos_path(@album)
  end

  test "should get edit when loged in" do
    login_as @user
    get :edit, user_id: @user.id, id: @album.to_param
    assert_response :success
    assert_not_nil assigns(:album)
  end
  
  test "should not get edit when loged in as another user" do
    login_as users(:two)
    get :edit, user_id: @user.id, id: @album.to_param
    access_denied_notallowed
  end
  
  test "should not get edit when not loged in" do
    get :edit, user_id: @user.id, id: @album.to_param
    access_denied_mustlogin
  end

  test "should update album when loged in" do
    login_as @user
    put :update, user_id: @user.id, id: @album.to_param, album: @album.attributes
    assert_redirected_to album_photos_path(assigns(:album))
    assert_equal I18n.t('albums.edit.updated'), flash[:message]
  end
  
  test "should not update album when loged in as another user" do
    login_as users(:two)
    put :update, user_id: @user.id, id: @album.to_param, album: @album.attributes
    access_denied_notallowed
  end
  
  test "should not update album when not loged in" do
    put :update, user_id: @user.id, id: @album.to_param, album: @album.attributes
    access_denied_mustlogin
  end

  test "should destroy album when loged in" do
    login_as @user
    assert_difference('Album.count', -1) do
      delete :destroy, user_id: @user.id, id: @album.to_param
    end
    
    assert_redirected_to user_albums_path(@user)
  end
  
  test "should destroy album and photos in it" do
    login_as @user
    assert_difference('Photo.count', -1 * @album.photos.count) do
      delete :destroy, user_id: @user.id, id: @album.to_param
    end
    
    assert_redirected_to user_albums_path(@user)
  end
  
  test "should destroy album and comments to photos in it" do
    login_as @user
    assert_difference('Comment.count', -1 * @album.comments.count) do
      delete :destroy, user_id: @user.id, id: @album.to_param
    end
    
    assert_redirected_to user_albums_path(@user)
  end
  
  test "should not destroy album when not loged in as another user" do
    login_as users(:two)
    assert_difference('Album.count', 0) do
      delete :destroy, user_id: @user.id, id: @album.to_param
    end
    
    access_denied_notallowed
  end
  
  test "should not destroy album when not loged in" do
    assert_difference('Album.count', 0) do
      delete :destroy, user_id: @user.id, id: @album.to_param
    end
    
    access_denied_mustlogin
  end
end
