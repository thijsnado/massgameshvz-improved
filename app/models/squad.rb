class Squad < ActiveRecord::Base
  belongs_to :squad_leader, :class_name => 'GameParticipation'
  has_many :squad_members, :class_name => 'GameParticipation'
  has_attached_file :avatar, :styles => { :large => ["700x700>", :png], :medium => ["300x300>", :png], :thumb => ["100x100>", :png] }
  
  attr_writer :squad_leader_username
  attr_writer :squad_member_usernames
  
  before_validation :set_squad_leader_by_username
  before_validation :set_squad_members_by_usernames
  
  validates_presence_of :squad_name
  
  after_create :make_leader_squad_leader
  after_save :set_squad_members

  validate :no_errors_on_squad_leader_username
  validate :no_errors_on_squad_member_usernames
  validate :no_errors_on_squad_member_squads
  validate :no_errors_on_squad_leader_squad
  validate :no_duplicate_squad_members
  validates_attachment_content_type :avatar, :content_type=>['image/jpeg', 'image/png', 'image/gif'], :less_than => 10.megabyte
  
  def add_squad_members
    @squad_member_usernames = self.squad_member_usernames
    @squad_member_usernames||= []
    (8 - @squad_member_usernames.size).times do 
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
      self.squad_members.order('rank asc').map{|m| m.user.username}
    else
      @squad_member_usernames
    end
  end
  
  def current_leader
    return squad_leader unless squad_leader.zombie?
    squad_members.order('rank asc').each do |member|
      return member if member.human?
    end
  end

  private 
  
  def set_squad_leader_by_username
    user = User.find_by_username(self.squad_leader_username)
    game_participation = user.current_participation || user.game_participations.new(:game_id => Game.current.id)
    unless game_participation || !self.squad_leader_username
      @squad_leader_username_error = self.squad_leader_username
    else
      @squad_leader_squad_error = self.squad_leader_username if game_participation.squadron && game_participation.squadron != self
      self.squad_leader = game_participation
    end
  end
  
  def set_squad_members_by_usernames
    @squad_member_username_error ||= []
    @squad_member_squad_error ||= []
    @squad_members = []
    @squad_member_usernames.each do |username|
      game_participation = User.find_by_username(username).current_participation rescue nil
      if(!game_participation && !username.blank?)
        @squad_member_username_error << username 
      elsif game_participation && game_participation.squad_id && game_participation.squad_id != self.id
        @squad_member_squad_error << username
      else
        @squad_members << game_participation unless username.blank?
      end
    end
  end
  
  def set_squad_members
    i = 0
    @squad_members.each do |squad_member|
      i += 1
      squad_member.rank = i
      squad_member.save :validate => false
      self.squad_members << squad_member
    end
  end
  
  def no_errors_on_squad_leader_username
    self.errors.add(:squad_leader, "#{@squad_leader_username_error} is not a real username") if @add_squad_leader_error
  end
  
  def no_errors_on_squad_member_usernames
    self.errors.add(:squad_members, "#{@squad_member_username_error.join(',')} are not real usernames") unless @add_squad_members_error.blank?
  end
  
  def no_errors_on_squad_member_squads
    self.errors.add(:squad_members, "#{@squad_member_squad_error.join(',')} are already in squads") unless @squad_member_squad_error.blank?
  end
  
  def no_errors_on_squad_leader_squad
    self.errors.add(:squad_leader, "#{@squad_leader_squad_error} is already in a squad") unless @squad_leader_squad_error.blank?
  end
  
  def no_duplicate_squad_members
    self.errors.add(:squad_members, "you can't have the same person listed twice in a squad") if (@squad_member_usernames.size != @squad_member_usernames.uniq.size) && (@squad_member_usernames.uniq.size == 1 && !@squad_member_usernames.uniq.first.blank?)
  end
  
  def make_leader_squad_leader
    l = self.squad_leader
    l.creature = Human::SQUAD
    l.save(:validate => false)
  end
end
