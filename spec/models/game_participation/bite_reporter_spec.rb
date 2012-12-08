require 'spec_helper'

class GameParticipation
  describe BiteReporter do
    let(:current_value_of_food){ 3.hours }
    let(:bite_shares_per_food){ 3 }

    let(:current_game) do
      Factory(:current_game,
              :time_per_food => current_value_of_food,
              :bite_shares_per_food => bite_shares_per_food
             )
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
        :zombie_expires_at => current_game.start_at + 3.hours + current_value_of_food,
        :bitten_events => [
          Factory(:bite_event,
                  :occured_at => current_game.start_at + 3.hours,
                  :zombie_expiration_calculation => current_game.start_at + current_game.time_per_food
                 )
          ]
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
      BiteReporter.record_bite(zombie_participation, human_participation)
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

    describe '#initialize' do
      it "does not allow human for zombie value" do
        human = normal_human_participation
        expect {
          BiteReporter.new(human, human)
        }.to raise_error(ArgumentError, "First argument must be zombie.")
      end

      it "does not allow zombie unless self bitten for zombie value" do
        human = normal_human_participation
        zombie = normal_zombie_participation
        self_bitten = self_bitten_zombie_participation

        expect {
          BiteReporter.new(zombie, zombie)
        }.to raise_error(ArgumentError, "Second argument must be human or self bitten zombie.")

        expect {
          BiteReporter.new(zombie, self_bitten)
        }.to_not raise_error(ArgumentError, "Second argument must be human or self bitten zombie.")
      end
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

      context "normal zombie biting self bitten zombie" do
        # Essentially we are covering the edge case where a human
        # gave the bite number to a zombie and then accidently reported
        # themselves as being self bitten. This allows the zombie
        # to retroactively take credit.
        let(:zombie_participation){ normal_zombie_participation }
        let(:human_participation){ self_bitten_zombie_participation }

        it "converts self bitten zombie into a normal zombie" do
          record_bite
          updated_human_participation.creature.should == Zombie::NORMAL
        end

        it "should not change victims zombie expires at time" do
          original_zombie_expires_at = human_participation.zombie_expires_at
          record_bite
          updated_human_participation.zombie_expires_at.should == original_zombie_expires_at
        end

        it "updates zombie expiration time based on zombification event instead of current time" do
          Timecop.freeze(current_game.start_at + 5.hours)
          record_bite
          zombie_expires_at = updated_zombie_participation.zombie_expires_at.to_time
          zombie_expires_at.should_not == Time.now + current_value_of_food
          zombie_expires_at.should == human_participation.zombification_event.zombie_expiration_calculation
        end
      end
    end
  end
end
