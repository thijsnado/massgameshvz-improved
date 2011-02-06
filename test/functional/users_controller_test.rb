require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:clean_human)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:humans)
    assert_not_nil assigns(:zombies)
    assert_not_nil assigns(:living_areas)
  end


  test "should show user" do
    get :show, :id => @user.to_param
    assert_response :success
  end

end
