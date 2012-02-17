ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def login_as(login_user)
    session[:current_user] = login_user
    @current_user = login_user
  end
  
  def access_denied_mustlogin
    assert_redirected_to root_path
    assert_equal I18n.t('mustbeloged_error'), flash[:error]
  end
  
  def access_denied_notallowed
    assert_redirected_to root_path
    assert_equal I18n.t('mustbeyours_error'), flash[:error]
  end
end
