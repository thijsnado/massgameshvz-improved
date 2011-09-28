require 'spec_helper'

describe PlayerStatusesController do
  render_views
  
  describe "GET 'show'" do
    let(:current_game){ Factory.create(:current_game)}
    let(:game_participation){Factory.create(:game_participation, :creature => Zombie::NORMAL, :game => current_game) }
    before do
      Timecop.freeze(current_game.start_at + 1.second)
    end
    
    after do
      Timecop.return
    end
    
    it 'should return an xml representation of a players status if given an id' do
      user = game_participation.user
      request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => user.id 
      
      player_status = {'creature_type' => 'zombie', 'name' => 'Regular Zombie', 'code' => 'normal', 'zombie_expires_at' => game_participation.zombie_expires_at}
      
      Hash.from_xml(response.body)['PlayerStatus'].should == player_status
    end
    
    it 'should return an xml representation of the players status with all attributes nil if user is not registered for game' do
      user = Factory(:user)
      request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => user.id 
      
      player_status = {'creature_type' => nil, 'name' => nil, 'code' => nil, 'zombie_expires_at' => nil}
      
      Hash.from_xml(response.body)['PlayerStatus'].should == player_status
    end
  end

end
