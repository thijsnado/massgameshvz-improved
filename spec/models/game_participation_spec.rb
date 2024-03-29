require 'spec_helper'

describe GameParticipation do
  let(:current_value_of_food){3.hours}
  let(:bite_shares_per_food){3}
  let(:current_game){Factory(:current_game, :time_per_food => current_value_of_food, :bite_shares_per_food => bite_shares_per_food)}

  let(:zombie_participation) do
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

  let(:human_participation) do
    Factory(:game_participation,
      :creature => Human::NORMAL,
      :game => current_game,
      :user_number => 'human_part'
    )
  end

  let(:squad_participation) do
    Factory(:game_participation,
      :creature => Human::SQUAD,
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

  after do
    Timecop.return
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

  describe "record_pseudo_bite" do
    let(:pseudo_bite){Factory(:pseudo_bite, :used => false)}

    it "increases the zombie expiration date" do
      zombie_participation.send :record_pseudo_bite, pseudo_bite
      zombie_participation.zombie_expires_at.should == Time.now + current_value_of_food.seconds
    end

    it "gives the zombie a pseudo_bite event" do
      zombie_participation.send :record_pseudo_bite, pseudo_bite
      zombie_participation.pseudo_bite_events.last.pseudo_bite.should == pseudo_bite
    end

    it "does not increase zombie expiration date if used" do
      pseudo_bite.used = true; pseudo_bite.save
      current_zombie_expires_at = zombie_participation.zombie_expires_at
      zombie_participation.send :record_pseudo_bite, pseudo_bite
      zombie_participation.zombie_expires_at.should == current_zombie_expires_at
    end

    it "does not increase zombie expiration date if zombie is dead" do
      zombie_participation.zombie_expires_at = Time.now - 1.day; zombie_participation.save
      zombie_participation.send :record_pseudo_bite, pseudo_bite
      zombie_participation.zombie_expires_at.should == Time.now - 1.day
    end

    it "gives the zombie a number of bite shares defined by the bite_shares_per_food" do
      zombie_participation.send(:record_pseudo_bite, pseudo_bite)
      zombie_participation.bite_shares.count.should == bite_shares_per_food
    end
  end

  describe "enter_user_number" do
    let(:pseudo_bite){Factory(:pseudo_bite, :used => false, :game => current_game)}

    it "calls report_bite if number is of a game participation and reporter is zombie" do
      zombie_participation
      human_participation
      current_game
      zombie_participation.should_receive(:report_bite).with(human_participation)
      zombie_participation.enter_user_number(human_participation.user_number)
    end

    it "calls report_bitten if number is of a game_participation and reporter is a human" do
      zombie_participation
      human_participation
      current_game
      human_participation.should_receive(:report_bitten).with(zombie_participation)
      human_participation.enter_user_number(zombie_participation.user_number)
    end

    it "calls record_pseudo_bite if number is of type pseudo_bite and game_participation is zombie" do
      zombie_participation
      human_participation
      current_game
      zombie_participation.should_receive(:record_pseudo_bite).with(pseudo_bite)
      zombie_participation.enter_user_number(pseudo_bite.code)
    end
  end

  describe "self_bite" do
    it "turns a human into a self bitten zombie" do
      human_participation.self_bite
      human_participation.creature.should == Zombie::SELF_BITTEN
    end

    it "creates a bite event where the participation and target are self" do
      human_participation.self_bite
      biting_event = human_participation.biting_events.last
      biting_event.target_object = human_participation
    end

    it "increases zombie_expires_at by value of food" do
      human_participation.self_bite
      human_participation.zombie_expires_at.should == Time.now + current_value_of_food
    end
  end
end
