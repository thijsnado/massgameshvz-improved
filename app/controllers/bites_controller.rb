class BitesController < ApplicationController
  
  def receive
    @bite_event = BiteEvent.new
  end
  
  def give
      @bite_event = BiteEvent.new
  end
  
  def create
    if params[:bite_type] == 'receive'
      @bite_event = BiteEvent.new(params[:bite_event])
      @zombie_participation = Game.current.game_participations.find_by_user_number(@bite_event.zombie_code)
      if @zombie_participation
        @current_user.current_participation.report_bitten(@zombie_participation)
        redirect_to root_url
      else
        redirect_to root_url
      end
    elsif params[:bite_type] == 'give'
      @bite_event = BiteEvent.new(params[:bite_event])
      @human_participation = Game.current.game_participations.find_by_user_number(@bite_event.human_code)
      if @human_participation
        @current_user.current_participation.report_bite(@human_participation)
        redirect_to root_url
      else
        redirect_to root_url
      end 
    end
  end
end