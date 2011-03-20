class Game < ActiveRecord::Base
  has_many :game_participations
  has_many :pseudo_bites
  
  def self.current
    return @current||= where("? BETWEEN signup_start_at AND end_at", Time.now).first
  end
  
  def signup(user)
    participation = GameParticipation.new
    participation.user = user
    participation.game = self
    return participation.save
  end
  
end
