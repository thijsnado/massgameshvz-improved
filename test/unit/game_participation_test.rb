require 'test_helper'

class GameParticipationTest < ActiveSupport::TestCase
  
  
  test "zombie can bite human" do 
  end
  
  test "human can be bitten zombie" do
  end
  
  test "human can be bitten by human" do
    Timecop.freeze(games(:current_game).start_at + 1.minute) do
      unreported = users(:unreported)
      clean_human = users(:clean_human)
    
      assert clean_human.is_human
    
      clean_human.report_bite unreported
    
      assert clean_human.is_zombie
    end
  end
end
