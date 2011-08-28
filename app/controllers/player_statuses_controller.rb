class PlayerStatusesController < ApplicationController

  def show
    user = User.find(params[:id])
    player_status = {:creature_type => nil, :code => nil, :name => nil}
    if game_participation = user.current_participation
      player_status[:creature_type] = game_participation.creature_type.underscore
      player_status[:code]          = game_participation.creature.code
      player_status[:name]          = game_participation.creature.name
    end

    render :xml => player_status.to_xml(:root => 'PlayerStatus')
  end

end