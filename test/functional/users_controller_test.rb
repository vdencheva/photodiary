require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_nil assigns(:users)
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: {username: 'tester20', password: 'testpass', email: 'tester22@example.com'}
    end

    assert_redirected_to user_path(assigns(:user))
    assert_equal I18n.t('views.user.created'), flash[:message]
  end

  test "should show user" do
    get :show, id: @user.to_param
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "should get edit when loged in" do
    login_as @user
    get :edit, id: @user.to_param
    assert_not_nil assigns(:user)
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "should not get edit when not loged in" do
    get :edit, id: @user.to_param
    access_denied
  end
  
  test "should not get edit when loged in as another user" do
    get :edit, id: @user.to_param
    login_as users(:two)
    access_denied
  end

  test "should update user when loged in" do
    login_as @user
    put :update, id: @user.to_param, user: @user.attributes
    assert_not_nil assigns(:user)
    assert_redirected_to user_path(assigns(:user))
    assert_equal I18n.t('views.user.updated'), flash[:message]
  end

  test "should not update user when not loged in" do
    put :update, id: @user.to_param, user: @user.attributes
    access_denied
  end

  test "should not update user when loged in as another user" do
    put :update, id: @user.to_param, user: @user.attributes
    login_as users(:two)
    access_denied
  end
  
  test "should destroy user when loged in" do
    login_as @user
    assert_difference('User.count', -1) do
      delete :destroy, id: @user.to_param
    end
    assert_redirected_to users_path
  end
  
  test "should not destroy user when not loged in" do
    delete :destroy, id: @user.to_param
    access_denied
  end
  
  test "should not destroy user when loged in as another user" do
    delete :destroy, id: @user.to_param
    login_as users(:two)
    access_denied
  end
  
  test "should get login" do
    get :login
    assert_response :success
  end
  
  test "should log in successfully" do
    post :login_process, user: { :username => "tester1", :password => "testpass" }
    assert_equal users(:one).id, session[:current_user][:id]
    assert_redirected_to root_path
    assert_equal I18n.t('views.user.login_succeeded'), flash[:message]
  end
  
  test "should not log in" do
    post :login_process, user: { :username => "tester1", :password => "testpas" }
    assert_nil session[:current_user]
    assert_equal I18n.t('views.user.login_error'), flash[:error]
  end
 
  test "should logout when loged in" do
    login_as @user
    get :logout 
    assert_nil session[:current_user]
    assert_redirected_to root_path
    assert_equal I18n.t('views.user.logout_succeeded'), flash[:message]
  end
  
  test "should not logout" do
    get :logout
    access_denied
  end
  
  def login_as(login_user)
    session[:current_user] = login_user
  end
  
  def access_denied
    assert_redirected_to root_path
    assert_equal I18n.t('views.mustbeloged_error'), flash[:error]
  end
  
end
