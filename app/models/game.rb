class Game < ActiveRecord::Base
  has_many :game_participations
  
  def self.current
    return where("? BETWEEN start_at AND end_at", Time.now).first
  end
  
  def signup(user)
    participation = GameParticipation.new
    participation.user = user
    participation.game = self
    return participation.save
  end
  
end
