require 'spec_helper'

class GameParticipation
  describe BiteReporter do
    let(:current_value_of_food){ 3.hours }
    let(:bite_shares_per_food){ 3 }

    let(:current_game) do
      Factory(:current_game,
              :time_per_food => current_value_of_food,
              :bite_shares_per_food => bite_shares_per_food)
    end

    let(:normal_zombie_participation) do
      Factory(:game_participation,
        :creature => Zombie::NORMAL,
        :game => current_game,
        :zombie_expires_at => current_game.start_at + 4.minutes
      )
    end

    let(:self_bitten_zombie_participation) do
      Factory(:game_participation,
        :creature => Zombie::SELF_BITTEN,
        :game => current_game,
        :bitten_events => [Factory(:bite_event, :occured_at => current_game.start_at + 1.second, :zombie_expiration_calculation => current_game.start_at + current_game.time_per_food)]
      )
    end

    let(:immortal_self_bitten_zombie_participation) do
      Factory(:game_participation,
        :creature => Zombie::IMMORTAL_SELF_BITTEN,
        :game => current_game,
        :bitten_events => [Factory(:bite_event, :occured_at => current_game.start_at + 1.second, :zombie_expiration_calculation => current_game.start_at + current_game.time_per_food)]
      )
    end

    let(:normal_human_participation) do
      Factory(:game_participation,
              :creature => Human::NORMAL,
              :game => current_game,
              :user_number => 'human_part'
             )
    end

    let(:squad_leader_human_participation) do
      Factory(:game_participation,
              :creature => Human::SQUAD,
              :game => current_game
             )
    end

    before do
      Timecop.freeze(current_game.start_at)
    end

    after do
      Timecop.return
    end

    def record_bite
      BiteReporter.new(zombie_participation, human_participation).record_bite
    end

    def updated_human_participation
      # we do a full find instead of reload since reload
      # only resets attributes and relations and not
      # instance variables
      GameParticipation.find(human_participation.id)
    end

    def updated_zombie_participation
      GameParticipation.find(zombie_participation.id)
    end

    shared_examples "any zombie with human victim" do
      it "converts a human into a Zombie" do
        record_bite
        updated_human_participation.creature.should == Zombie::NORMAL
      end

      it "increments victims expiration timer by current time + value of food" do
        record_bite
        updated_human_participation.zombie_expires_at.should == Time.now + current_value_of_food
      end
    end

    shared_examples "mortal zombie with normal human victim" do
      it "increments zombies expiration timer by current time + value of food" do
        record_bite
        updated_zombie_participation.zombie_expires_at.should == Time.now + current_value_of_food
      end

      it "should not change creature" do
        original_creature = zombie_participation.creature
        record_bite
        updated_zombie_participation.creature.should == original_creature
      end
    end

    describe '#record_bite' do
      context "non-immortal zombie with normal human" do
        let(:human_participation){ normal_human_participation }
        let(:zombie_participation){ normal_zombie_participation }

        it_behaves_like "any zombie with human victim"
        it_behaves_like "mortal zombie with normal human victim"
      end

      context "non-immortal zombie with human that causes immortality when bitten (generally squad leaders)" do
        let(:human_participation){ squad_leader_human_participation }
        let(:zombie_participation){ normal_zombie_participation }

        it_behaves_like "any zombie with human victim"

        it "sets creature to Zombie::IMMORTAL" do
          record_bite
          updated_zombie_participation.creature.should == Zombie::IMMORTAL
        end
      end

      context "self bitten zombie with human that causes immortality when bitten" do
        let(:human_participation){ squad_leader_human_participation }
        let(:zombie_participation){ self_bitten_zombie_participation }

        it_behaves_like "any zombie with human victim"

        it "sets creature to Zombie::IMMORTAL_SELF_BITTEN" do
          record_bite
          updated_zombie_participation.creature.should == Zombie::IMMORTAL_SELF_BITTEN
        end
      end

      context "already immmortal zombie with human that causes immortality when bitten" do
        let(:human_participation){ squad_leader_human_participation }
        let(:zombie_participation){ immortal_self_bitten_zombie_participation }

        it_behaves_like "any zombie with human victim"

        it "sets creature to Zombie::IMMORTAL_SELF_BITTEN" do
          record_bite
          updated_zombie_participation.creature.should == Zombie::IMMORTAL_SELF_BITTEN
        end
      end
    end
  end
end
