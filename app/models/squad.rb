class Squad < ActiveRecord::Base
  belongs_to :squad_leader, :class_name => 'GameParticipation'
  has_many :squad_members, :class_name => 'GameParticipation'
  
  attr_writer :squad_leader_username
  attr_writer :squad_member_usernames
  
  before_validation :set_squad_leader_by_username
  before_validation :set_squad_members_by_usernames
  
  def squad_leader_username
    unless @squad_leader_username
      self.squad_leader.user.username rescue nil
    else
      @squad_leader_username
    end
  end
  
  def squad_member_usernames
    unless @squad_member_usernames
      self.squad_members.map{|m| m.user.username}
    else
      @squad_member_usernames
    end
  end

  private 
  
  def set_squad_leader_by_username
    game_participation = User.find_by_username(self.squad_leader_username).current_participation rescue nil
    unless game_participation || !self.squad_leader_username
      @add_squad_leader_error = self.squad_leader_username
    else
      self.squad_leader = game_participation
    end
  end
  
  def set_squad_members_by_usernames
    @add_squad_members_error 
    self.squad_member_usernames.each do |username|
      game_participation = User.find_by_username(self.squad_leader_username).current_participation rescue nil
      unless game_participation || !username
        @add_squad_members_error << username
      else
        
      end
    end
  end
end
