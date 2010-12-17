require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:humans)
    assert_not_nil assigns(:zombies)
    assert_not_nil assigns(:living_areas)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_select('form')
    assert_select('input[name=?]', 'user[first_name]')
    assert_select('input[name=?]', 'user[last_name]')
    assert_select('input[name=?]', 'user[password]')
    assert_select('input[name=?]', 'user[password_confirmation]')
    assert_select('input[name=?]', 'user[email_address]')
    assert_select('input[name=?]', 'user[phone]')
    assert_select('input[name=?]', 'user[rules_read]')
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => @user.attributes
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, :id => @user.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @user.to_param
    assert_response :success
    assert_select('form')
    assert_select('input[name=?]', 'user[first_name]')
    assert_select('input[name=?]', 'user[last_name]')
    assert_select('input[name=?]', 'user[password]')
    assert_select('input[name=?]', 'user[password_confirmation]')
    assert_select('input[name=?]', 'user[email_address]')
    assert_select('input[name=?]', 'user[phone]')
  end

  test "should update user" do
    put :update, :id => @user.to_param, :user => @user.attributes
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => @user.to_param
    end

    assert_redirected_to users_path
  end
end
