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
  
end