require 'spec_helper'

describe User do
  
  before do
    Timecop.freeze(current_game.start_at)
  end
  
  after do
    Timecop.return
  end
  
  describe 'has_not_signed_up' do
    let(:current_game){ Factory(:current_game) }
    let(:user){ Factory(:user) }
    
    it 'returns true if user has not signed up for game' do
      user.has_not_signed_up.should be_true
    end
    
    it 'returns false if user has signed up for game' do
      Factory(:game_participation, :game => current_game, :user => user)
      
      user.has_not_signed_up.should_not be_true
    end
  end
end