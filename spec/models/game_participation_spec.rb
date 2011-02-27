require 'spec_helper'

describe GameParticipation do
  let(:current_value_of_food){3.hours}
  let(:current_game){Factory(:current_game, :time_per_food => current_value_of_food)}
  let(:zombie_participation) do
    Factory(:game_participation,
      :creature => Zombie::NORMAL,
      :game => current_game
    )
  end
  let(:self_bitten_zombie_participation) do
    Factory(:game_participation,
      :creature => Zombie::SELF_BITTEN,
      :game => current_game
    )
  end
  let(:human_participation) do
    Factory(:game_participation,
      :creature => Human::NORMAL,
      :game => current_game
    )
  end
  let(:unreported_zombie_participation) do
    Factory(:game_participation,
      :creature => Human::NORMAL,
      :game => current_game
    )
  end
  before do
    Timecop.freeze(current_game.start_at)
  end
  describe 'report_bite' do
    it "allows a zombie participation to report biting a human" do
      zombie_participation.should_receive(:record_bite).with(human_participation)
      zombie_participation.report_bite(human_participation)
    end
    it "allows a zombie participation to report biting a self bitten zombie" do
      zombie_participation.should_receive(:record_bite).with(self_bitten_zombie_participation)
      zombie_participation.report_bite(self_bitten_zombie_participation)
    end
  end
  describe 'report_bitten' do
    it "allows a human participation to report being bitten by zombie" do
      zombie_participation.should_receive(:record_bite).with(human_participation)
      human_participation.report_bitten(zombie_participation)
    end
    it "allows a human participation to report being bitten by a unreported zombie" do
      unreported_zombie_participation.should_receive(:record_bite).with(human_participation)
      human_participation.report_bitten(unreported_zombie_participation)
    end
  end
  describe "record_bite" do
    context "a zombie bites a human" do
      it "turns the human participation that was bitten into a zombie" do
        zombie_participation.send(:record_bite, human_participation)
        human_participation.creature.should == Zombie::NORMAL
      end
      it "adjusts the zombies expiration date to the current time plus the value of food" do
        zombie_participation.send(:record_bite, human_participation)
        zombie_participation.zombie_expires_at.should == Time.now + current_value_of_food
      end
      it "gives the zombie credit for biting the human" do
        zombie_participation.send(:record_bite, human_participation)
        zombie_participation.biting_events.last.bitten_participation.should == human_participation
      end
    end
    context "an unreported zombie bites a human" do
      it "turns the human participation that was bitten into a zombie" do
        unreported_zombie_participation.send(:record_bite, human_participation)
        human_participation.creature.should == Zombie::NORMAL
      end
      it "turns the unreported zombie into a self bitten zombie" do
        unreported_zombie_participation.send(:record_bite, human_participation)
        unreported_zombie_participation.creature.should == Zombie::SELF_BITTEN
      end
      it "adjusts the unreported zombies expiration date to the current time plus the value of food" do
        unreported_zombie_participation.send(:record_bite, human_participation)
        unreported_zombie_participation.zombie_expires_at.should == Time.now + current_value_of_food
      end
      it "gives the unreported zombie credit for biting the human" do
        unreported_zombie_participation.send(:record_bite, human_participation)
        unreported_zombie_participation.biting_events.last.bitten_participation.should == human_participation
      end
    end
    context "a zombie bites a self bitten zombie" do
      it "turns the self bitten zombie into a normal zombie" do
        zombie_participation.send(:record_bite, self_bitten_zombie_participation)
        self_bitten_zombie_participation.creature.should == Zombie::NORMAL
      end
      it "adjusts the zombies expiration date to the time of self bitification plus the value of food" do
        zombie_participation.send(:record_bite, self_bitten_zombie_participation)
        zombie_participation.zombie_expires_at.should == self_bitten_zombie_participation.zombification_time + current_value_of_food
      end
    end
  end  
end
