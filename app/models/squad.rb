class Squad < ActiveRecord::Base
  belongs_to :squad_leader, :class_name => 'GameParticipation'
  has_many :squad_members, :class_name => 'GameParticipation'
  
  attr_writer :squad_leader_username
  attr_writer :squad_member_usernames
  
  before_validation :set_squad_leader_by_username
  before_validation :set_squad_members_by_usernames
  
  after_create :make_leader_squad_leader

  def validate
    no_errors_on_squad_leader
    no_errors_on_squad_members
  end
  
  def add_squad_members
    return unless self.squad_members.blank?
    @squad_member_usernames = []
    8.times do 
      @squad_member_usernames << nil
    end
  end
  
  
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
    @add_squad_members_error ||= []
    @squad_member_usernames.each do |username|
      game_participation = User.find_by_username(username).current_participation rescue nil
      unless game_participation || username.blank?
        @add_squad_members_error << username
      else
        self.squad_members << game_participation unless username.blank?
      end
    end
  end
  
  def no_errors_on_squad_leader
    self.errors.add(:squad_leader, "#{@add_squad_leader_error} is not a real username") if @add_squad_leader_error
  end
  
  def no_errors_on_squad_members
    self.errors.add(:squad_members, "#{@add_squad_members_error.join(',')} are not real usernames") unless @add_squad_members_error.blank?
  end
  
  def make_leader_squad_leader
    l = self.squad_leader
    l.creature = Human::SQUAD
    l.save(false)
  end
end
