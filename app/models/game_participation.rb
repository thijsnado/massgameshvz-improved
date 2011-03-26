class GameParticipation < ActiveRecord::Base
  
  belongs_to :game
  belongs_to :user
  belongs_to :creature, :polymorphic => true
  belongs_to :living_area
  belongs_to :squad
  has_one :squadrin, :class_name => 'Squad', :foreign_key => 'squad_leader_id'
  
  has_many :biting_events, :class_name => 'BiteEvent'
  has_many :bitten_events, :class_name => 'BiteEvent', :as => :target_object
  has_many :pseudo_bite_events
  has_many :bite_shares, :through => :biting_events
  
  before_create :set_zombie_expires_at
  before_save :format_user_number
  
  validate :validate_not_outside_signup_period
  validates_uniqueness_of :user_id, :scope => :game_id
  validates_uniqueness_of :user_number
  
  def self.zombie
    where(:creature_type => 'Zombie')
  end
  
  def self.joins_with_zombie
    joins("INNER JOIN zombies on game_participations.creature_id = zombies.id")
  end
  
  def self.original_zombies
    zombie.joins_with_zombie.where(:zombies => {:id => Zombie::ORIGINAL.id})
  end
  
  def self.not_immortal
    zombie.joins_with_zombie.where(:zombies => {:immortal => false})
  end
  
  def self.not_dead
    where("zombie_expires_at > ?", Time.now)
  end
  
  def self.original_zombie_requests
    where(:original_zombie_request => true)
  end
  
  def self.original_zombies_and_zombie_requests
    current_game = Game.current
    if current_game
      game_participations = current_game.game_participations.original_zombies.includes('user').order(:user => :username)
      game_participations = game_participations.to_a +  current_game.game_participations.original_zombie_requests.where("creature_type != 'Zombie' OR creature_type is null").includes('user').order(:user => :username).to_a
      return game_participations.sort{|a, b| a.user.username <=> b.user.username}
    else
      return []
    end
  end
  
  def self_bite
    time = Time.now
    self.creature = Zombie::SELF_BITTEN
    self.biting_events.create(:bitten_participation => self, :occured_at => time)
    self.zombie_expires_at = time + self.game.time_per_food.seconds
    return save
  end
  
  def enter_user_number(val)
    val = Codeinator.format_code(val)
    game_participation = Game.current.game_participations.find_by_user_number(val)
    if zombie?
      if game_participation
        return report_bite(game_participation) if game_participation
      else
        pseudo_bite = Game.current.pseudo_bites.find_by_code(val)
        return record_pseudo_bite(pseudo_bite) if pseudo_bite
      end
    elsif human?
      return report_bitten(game_participation) if game_participation
    end
  end
  
  def human?
    return creature_type == 'Human'
  end
  
  def zombie?
    return creature_type == 'Zombie'
  end
  
  def dead?
    return true if mortal? && self.zombie_expires_at.to_i < Time.now.to_i
  end
  
  def mortal?
    return true if zombie? && self.creature.immortal == false
  end
  
  def immortal?
    return !mortal?
  end
  
  def original_zombie?
    return true if zombie? && self.creature == Zombie::ORIGINAL
  end
  
  #Used when reporting who a user bit (A zombie reports he bit a human)
  def report_bite(game_participation)
    if zombie? && (game_participation.human? || game_participation.creature == Zombie::SELF_BITTEN)
      return record_bite(game_participation)
    else
      return false
    end
  end
  
  #Used when reporting that a user got bitten (A human reports he got bit by a zombie)
  def report_bitten(game_participation)
    if human?
      return game_participation.record_bite(self)
    else
      return false
    end
  end
  
  def current_parent
    if zombie?
      return bitten_events.order('occured_at desc').first.biter_participation
    else
      return nil
    end
  end
  
  def is_expired
    return self.zombie_expires_at < Time.now unless self.creature.immortal
    return false
  end
  
  def zombification_event
    self.bitten_events.first
  end
  
  def format_user_number
    generate_user_number unless self.user_number
    self.user_number = Codeinator.format_code(self.user_number)
  end
  
  def set_zombie_expires_at
    self.zombie_expires_at = Time.now + self.game.time_per_food.seconds unless self.zombie_expires_at || !self.mortal?
  end
  
  def generate_user_number
    self.user_number = Digest::SHA1.hexdigest(rand.to_s + "HVZ RAWKS!!!" + Time.now.to_s)[0, 10]
  end
  
  def record_pseudo_bite(pseudo_bite)
    return false if pseudo_bite.used? || dead?
    self.zombie_expires_at = Time.now + self.game.time_per_food
    pseudo_bite_event = PseudoBiteEvent.new :pseudo_bite => pseudo_bite, :zombie_participation => self, :zombie_expiration_calculation => self.zombie_expires_at
    create_bite_shares(pseudo_bite_event)
    pseudo_bite_event.save
    pseudo_bite.used = true
    pseudo_bite.save
    return save
  end
  
  def record_bite(game_participation)
    time = Time.now
    if dead?
      return false
    end
    
    #adjust starvation time
    if game_participation.human?
      game_participation.creature = Zombie::NORMAL
      game_participation.zombie_expires_at = time + self.game.time_per_food
      game_participation.save(false)
      self.zombie_expires_at = time + self.game.time_per_food
    elsif game_participation.creature == Zombie::SELF_BITTEN
      game_participation.creature = Zombie::NORMAL
      game_participation.save(false)
      zombie_expires_at = game_participation.zombification_event.zombie_expiration_calculation
      self.zombie_expires_at = zombie_expires_at unless zombie_expires_at < self.zombie_expires_at
    end
    
    #record bite event
    bite_event = BiteEvent.new
    bite_event.biter_participation = self
    bite_event.bitten_participation = game_participation
    bite_event.occured_at = time
    bite_event.zombie_expiration_calculation = self.zombie_expires_at
    bite_event.save(false)
    
    create_bite_shares(bite_event)
    
    #handle different creature types
    if self.human?
      self.creature = Zombie::SELF_BITTEN
    end
    return save(false)
  end
  
  def create_bite_shares(bite_event)
    game.bite_shares_per_food.times do
      bite_share = BiteShare.new
      bite_share.bite_event = bite_event
      bite_share.save
    end
  end
  
  def validate_not_outside_signup_period
    unless Time.now.between? game.signup_start_at, game.signup_end_at or not new_record?
      errors.add(:game, "Signup period for this game has passed")
    end
  end
end
