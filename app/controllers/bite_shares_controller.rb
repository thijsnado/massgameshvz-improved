class BiteSharesController < ApplicationController
  
  before_filter :must_be_playable
  before_filter :must_be_zombie
  
  def index
    @bite_shares = @current_user.current_participation.bite_shares
  end
  
  def share
    @zombie_participations = GameParticipation.zombie.not_immortal.not_dead.includes(:user)
    @bite_share = BiteShare.find(params[:id])
    return unless @bite_share.game_participation = @current_user.current_participation
  end

end