require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  fixtures :all
  
  test "Login and create album" do
    login
    
    get "/users/#{session["current_user"]["id"]}/albums/new"
    assert_response :success
    
    post_via_redirect "/users/#{session["current_user"]["id"]}/albums", album: { title: "test album", description: "" }
    assert_equal "/users/#{session["current_user"]["id"]}/albums", path
    assert_equal I18n.t('albums.new.created'), flash[:message]
    assert_response :success
    assert assigns(:albums)
    
    logout
  end
  
  test "Login and delete album" do
    login
    
    get "/users/#{session["current_user"]["id"]}/albums/"
    assert_response :success
    assert assigns(:albums)
    
    delete_via_redirect "/users/#{session["current_user"]["id"]}/albums/#{albums(:one).id}"
    assert_equal "/users/#{session["current_user"]["id"]}/albums", path
    assert_response :success
    assert assigns(:albums)
    
    logout
  end
  
  test "Login and upload photo" do
    login
    
    get "/albums/#{albums(:one).id}/photos/new"
    assert_response :success
    
    post_via_redirect "/albums/#{albums(:one).id}/photos", photo: { file: fixture_file_upload('DSC_5729.jpg', 'image/jpeg', :binary) }
    assert_equal "/albums/#{albums(:one).id}/photos/#{assigns(:photo).id}", path
    assert_equal I18n.t('photos.new.created'), flash[:message]
    assert_response :success
    assert assigns(:photo)
    
    logout
  end
  
  test "Login and delete photo" do
    login
    
    get "/albums/#{albums(:one).id}/photos/#{photos(:one).id}"
    assert_response :success
    assert assigns(:photo)
    
    delete_via_redirect "/albums/#{albums(:one).id}/photos/#{photos(:one).id}"
    assert_equal "/albums/#{albums(:one).id}/photos", path
    assert_response :success
    assert assigns(:photos)
    
    logout
  end
  
  test "Login and add comment" do
    login
    
    get "/albums/#{albums(:one).id}/photos/#{photos(:one).id}"
    assert_response :success
    assert assigns(:photo)
    
    post_via_redirect "/albums/#{albums(:one).id}/photos/#{photos(:one).id}/comments", comment: { body: "test comment" }
    assert_equal "/albums/#{albums(:one).id}/photos/#{photos(:one).id}", path
    assert_equal I18n.t('comments.new.created'), flash[:message]
    assert_response :success
    assert assigns(:photo)
    
    logout
  end
  
  test "Login and edit comment" do
    login
        
    album_id = albums(:one).id
    photo_id = photos(:one).id
    comment_id = comments(:one).id
    
    get "/albums/#{album_id}/photos/#{photo_id}"
    assert_response :success
    assert assigns(:photo)
    
    get "/albums/#{album_id}/photos/#{photo_id}/comments/#{comment_id}/edit"
    assert_response :success
    assert assigns(:comment)
    
    put_via_redirect "/albums/#{album_id}/photos/#{photo_id}/comments/#{comment_id}", comment: { body: "other test comment" }
    assert_equal "/albums/#{album_id}/photos/#{photo_id}", path
    assert_equal I18n.t('comments.edit.updated'), flash[:message]
    assert_response :success
    assert assigns(:photo)
    
    logout
  end
  
  def login
    get "/login"
    assert_response :success
 
    post_via_redirect "/login", user: {  username: "tester1", password: "testpass" }
    assert_equal '/', path
    assert_equal I18n.t('users.login.succeeded'), flash[:message]
  end
  
  def logout
    delete_via_redirect "/logout"
    assert_equal '/', path
    assert_equal I18n.t('user.logout.succeeded'), flash[:message]
  end
end
