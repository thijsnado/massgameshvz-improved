require 'spec_helper'

describe Game do
  
  context '#squads' do
    let(:game){Factory(:current_game)}
    let(:squad_leader){Factory(:game_participation, :creature => Human::SQUAD, :game => game)}
    let(:squad_member){Factory(:game_participation, :creature => Human::NORMAL, :game => game)}
    let(:squad){Factory(:squad, :squad_leader_username => squad_leader.user.username, :squad_member_usernames => [squad_member.user.username])}
    let(:previous_game){Factory(:game)}
    let(:previous_squad_leader){Factory(:game_participation, :creature => Human::SQUAD, :game => previous_game)}
    let(:previous_squad_member){Factory(:game_participation, :creature => Human::NORMAL, :game => previous_game)}
    let(:previous_squad){Factory(:squad, :squad_leader_username => previous_squad_leader.user.username, :squad_member_usernames => [previous_squad_member.user.username])}
    
    before do
      Timecop.freeze game.start_at do 
        squad_leader
        squad_member
        squad
      end
      Timecop.freeze previous_game.start_at do 
        previous_squad_leader
        previous_squad_member
        previous_squad
      end
    end
    
    it 'returns all squads for a game' do
      Timecop.freeze game.start_at do        
        game.squads.should include(squad)
      end
    end
    
    it 'does not return squads that belong to another game' do
      Timecop.freeze game.start_at do        
        game.squads.should_not include(previous_squad)
      end
    end
  end
  
  context '#paused?' do
    let(:game){Factory(:current_game)}
    before do
      Timecop.freeze game.start_at
      game.pause_until Time.now + 5.hours
    end
    after do
      Timecop.return
    end
    
    it 'returns true if Time.now is between pause_starts_at and pause_ends_at' do
      Timecop.freeze game.pause_starts_at + 3.hours
      game.should be_paused
    end
    
    it 'returns false if Time.now is not between pause_starts_at and pause_ends_at' do
      Timecop.freeze game.pause_starts_at - 3.hours
      game.should_not be_paused
    end
  end
  
  context '#unpause_game' do
    let(:game){Factory(:current_game)}
    #TODO: move these to factories
    let(:zombie_time){ game.start_at + 5.minutes}
    let(:self_bitten_zombie_time){ game.start_at + 10.minutes}
    let(:immortal_zombie_time){ game.start_at + 15.minutes}
    let(:zombie) do
      Factory(:game_participation,
        :creature => Zombie::NORMAL,
        :game => game,
        :zombie_expires_at => zombie_time
      )
    end
    let(:self_bitten_zombie) do
      Factory(:game_participation,
        :creature => Zombie::SELF_BITTEN,
        :game => game,
        :zombie_expires_at => self_bitten_zombie_time
      )
    end
    let(:immortal_zombie) do
      Factory(:game_participation,
        :creature => Zombie::IMMORTAL,
        :game => game,
        :zombie_expires_at => immortal_zombie_time
      )
    end
    
    before do
      Timecop.freeze game.start_at + 1.second
      zombie
      self_bitten_zombie
      immortal_zombie
      game.pause_until Time.now + 5.hours
    end
    
    after do
      Timecop.return
    end
    
    it 'if game is paused, unpauses and sets back expiration dates for mortal zombies' do
      Timecop.freeze game.pause_starts_at + 2.hours
      game.unpause_game
      zombie.reload.zombie_expires_at.should== zombie_time + 2.hours
      self_bitten_zombie.reload.zombie_expires_at.should == self_bitten_zombie_time + 2.hours
      immortal_zombie.reload.zombie_expires_at.should_not == immortal_zombie_time + 2.hours
      game.pause_ends_at.should be_nil
    end
  end
end