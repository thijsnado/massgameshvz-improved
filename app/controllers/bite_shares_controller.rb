class BiteSharesController < ApplicationController
  
  before_filter :must_be_playable
  before_filter :must_be_zombie
  
  def index
    @bite_shares = @current_user.current_participation.bite_shares.not_used
  end
  
  def share
    @bite_share = BiteShare.find(params[:id])
    return unless @bite_share.game_participation = @current_user.current_participation
  end
  
  def update
    @bite_share = BiteShare.find(params[:id])
    return unless @bite_share.game_participation = @current_user.current_participation
    game_participation = User.find_by_username(params[:username]).current_participation rescue nil
    if @bite_share.share(game_participation)
      flash[:notice] = 'You shared your bite with ' + params[:username]
    else
      flash[:notice] = 'The username you entered was either invalid, not a zombie, dead, or an immortal zombie. Please type in the username of a mortal, living zombie.'
    end
    redirect_to bite_shares_url
  end
  
  def usernames
    username = params[:username]
    logger.debug "the username is #{username}"
    @usernames = Game.current.game_participations.includes(:user).where("users.id is not null and users.username like ? and game_participations.creature_type = ?", "%#{username}%", 'Zombie').map{|gp| gp.user.username }
    render :partial => 'layouts/usernames_autocomplete'
  end

end