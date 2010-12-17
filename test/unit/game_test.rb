require 'test_helper'

class GameTest < ActiveSupport::TestCase

  test "user cannot sign up outside signup period" do
    Timecop.freeze(games(:current_game).signup_end_at + 1.minute) do
      assert !games(:current_game).signup(users(:not_signed_up))
    end
    Timecop.freeze(games(:current_game).signup_start_at - 1.minute) do
      assert !games(:current_game).signup(users(:not_signed_up))
    end 
  end
  
  test "user can signup within signup period" do
    Timecop.freeze(games(:current_game).signup_end_at - 1.minute) do
      assert games(:current_game).signup(users(:not_signed_up))
    end
    GameParticipation.destroy_all
    Timecop.freeze(games(:current_game).signup_start_at + 1.minute) do
      assert games(:current_game).signup(users(:not_signed_up))
    end
  end
  
  test "user can only signup once for same game" do
    Timecop.freeze(games(:current_game).signup_start_at + 1.minute) do
      assert games(:current_game).signup(users(:not_signed_up))
      assert !games(:current_game).signup(users(:not_signed_up))
    end
  end
  
  test "can modify after signup period" do
    Timecop.freeze(games(:current_game).signup_end_at + 1.minute) do
      participation = game_participations(:unassigned_pariticipation)
      participation.creature = humans(:normal)
      assert participation.save
    end
  end
  
  test "current game loads correctly" do
    Timecop.freeze(games(:current_game).start_at) do
      assert_equal Game.current, games(:current_game)
    end
  end
  
end
