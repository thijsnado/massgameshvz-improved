class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :game_participations
  
  validates :email_address, :email_domain => true
  
  attr_accessor :rules_read
  
  def current_participation
    @current_participation ||= Game.current.game_participations.find_by_user_id(id)
  end
  
end
