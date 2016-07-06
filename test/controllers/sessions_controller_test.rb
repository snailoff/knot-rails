require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get login_do" do
    get :login_do
    assert_response :success
  end

  test "should get logout" do
    get :logout
    assert_response :success
  end

end
