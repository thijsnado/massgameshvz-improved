require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  setup do
    @game = games(:one)
  end

  test "should get index" do
    Timecop.freeze(games(:current_game).start_at) do
      get :index
      assert_response :success
      assert_not_nil assigns(:game)
      assert_not_nil assigns(:humans)
      assert_not_nil assigns(:zombies)
      assert_not_nil assigns(:living_areas)
    end
  end


  test "should show game" do
    get :show, :id => @game.to_param
    assert_response :success
  end

end
