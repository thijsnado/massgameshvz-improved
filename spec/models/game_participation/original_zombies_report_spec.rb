require 'spec_helper'

class GameParticipation
  describe OriginalZombiesReport do
    describe '#self.original_zombies_and_zombie_requests' do
      let(:current_game) do
        Factory(:current_game)
      end

      before do
        Timecop.freeze(current_game.start_at)
      end

      after do
        Timecop.return
      end

      it "should return all original zombies and original zombie requests" do
        original_zombie = Factory(:game_participation,
                                  :creature => Zombie::ORIGINAL,
                                  :game => current_game)

        unassigned_zombie_request = Factory(:game_participation,
                                            :original_zombie_request => true,
                                            :game => current_game)

        human_zombie_request = Factory(:game_participation,
                                       :original_zombie_request => true,
                                       :creature => Human::NORMAL,
                                       :game => current_game)

        results = OriginalZombiesReport.new.original_zombies_and_original_zombie_requests
        results.size.should == 3
        results.should include(original_zombie)
        results.should include(unassigned_zombie_request)
        results.should include(human_zombie_request)
      end

      it "should return an empty list if no game is occuring" do
        Game.destroy_all
        results = OriginalZombiesReport.new.original_zombies_and_original_zombie_requests
        results.size.should == 0
      end
    end
  end
end
