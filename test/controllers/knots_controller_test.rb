require 'test_helper'

class KnotsControllerTest < ActionController::TestCase
  setup do
    @knot = knots(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:knots)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create knot" do
    assert_difference('Knot.count') do
      post :create, knot: { content: @knot.content, name: @knot.name }
    end

    assert_redirected_to knot_path(assigns(:knot))
  end

  test "should show knot" do
    get :show, id: @knot
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @knot
    assert_response :success
  end

  test "should update knot" do
    patch :update, id: @knot, knot: { content: @knot.content, name: @knot.name }
    assert_redirected_to knot_path(assigns(:knot))
  end

  test "should destroy knot" do
    assert_difference('Knot.count', -1) do
      delete :destroy, id: @knot
    end

    assert_redirected_to knots_path
  end
end
