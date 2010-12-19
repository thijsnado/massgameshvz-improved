class User < ActiveRecord::Base
  has_many :game_participations
  
  attr_accessor :password
  attr_accessor :password_confirmation
  attr_accessor :rules_read
  
  def current_participation
    @current_participation ||= Game.current.game_participations.find_by_user_id(id)
  end
  
end
