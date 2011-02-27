require 'spec_helper'

describe BiteShare do
  describe 'share_bite' do
    let(:current_game){Factory(:current_game)}
    let(:zombie_expiration_calculation){current_game.start_at + 5.hours}
    let(:bite_event) do
      Factory(:bite_event, 
        :zombie_expiration_calculation => zombie_expiration_calculation,
        :bite_shares => [Factory(:bite_share, :used => false)]
      )
    end
    let(:zombie_participation) do
      Factory(:game_participation,
        :creature => Zombie::NORMAL,
        :game => current_game,
        :zombie_expires_at => current_game.start_at + 4.minutes,
        :biting_events => [bite_event]
      )
    end
    let(:zombie_participation_2) do
      Factory(:game_participation,
        :creature => Zombie::NORMAL,
        :game => current_game,
        :zombie_expires_at => current_game.start_at + 4.minutes
      )
    end
    before do
      Timecop.freeze(current_game.start_at)
    end
    it "should extend the life of another zombie participation to the recorded starve time increase" do
      zombie_participation.bite_shares.first.share(zombie_participation_2)
      zombie_participation_2.zombie_expires_at.should == zombie_expiration_calculation
    end
  end
end
