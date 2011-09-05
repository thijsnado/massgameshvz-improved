class PlayerStatusesController < ApplicationController

  def show
    user = User.find(params[:id])
    if stale?(:etag => user, :last_modified => user.updated_at, :public => true)
      player_status = {:creature_type => nil, :code => nil, :name => nil, :zombie_expires_at => nil}
      if game_participation = user.current_participation
        player_status[:creature_type]     = game_participation.creature_type.underscore
        player_status[:code]              = game_participation.creature.code
        player_status[:name]              = game_participation.creature.name
        player_status[:zombie_expires_at] = game_participation.zombie_expires_at
      end

      render :xml => player_status.to_xml(:root => 'PlayerStatus')
    end
  end

end