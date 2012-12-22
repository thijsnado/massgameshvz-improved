class GameParticipation < ActiveRecord::Base

  belongs_to :game, :touch => true
  belongs_to :user, :touch => true
  belongs_to :creature, :polymorphic => true
  belongs_to :living_area
  belongs_to :squad, :touch => true
  has_one :squadron, :class_name => 'Squad', :foreign_key => 'squad_leader_id'

  has_many :biting_events, :class_name => 'BiteEvent'
  has_many :bitten_events, :class_name => 'BiteEvent', :as => :target_object
  has_many :pseudo_bite_events
  has_many :bite_shares, :through => :biting_events

  before_create :set_zombie_expires_at
  before_create :set_to_human_if_not_set
  before_save :format_user_number

  validate :validate_not_outside_signup_period
  validates_uniqueness_of :user_id, :scope => :game_id
  validates_uniqueness_of :user_number

  attr_protected :user_number
  attr_protected :creature_type
  attr_protected :creature_id
  attr_protected :squad_id
  attr_protected :rank

  def self.zombie
    where(:creature_type => 'Zombie')
  end

  def self.joins_with_zombie
    zombie.joins("INNER JOIN zombies on game_participations.creature_id = zombies.id")
  end

  def self.humans
    where(:creature_type => 'Human')
  end

  def self.mortal_zombies
    joins_with_zombie.where(:zombies => {:immortal => false})
  end

  def self.immortal_zombies
    joins_with_zombie.where(:zombies => {:immortal => true})
  end

  def self.not_dead
    where("zombie_expires_at > ?", Time.now)
  end

  def self.dead
    where("game_participations.zombie_expires_at < ? AND game_participations.creature_type = 'Zombie'", Time.now)
  end

  def self.top_zombies
    case ActiveRecord::Base.connection.adapter_name
    when 'PostgreSQL'
      count_select = 'count("events"."id") as bite_count'
    else
      count_select = 'count(`events`.`id`) as bite_count'
    end
    joins(:biting_events).select([count_select, :game_participation_id, :user_id]).group([:game_participation_id, :user_id]).order('bite_count desc')
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

  def vaccinatable?
    return zombie? && self.creature.vaccinatable && !dead?
  end

  def original_zombie?
    return true if zombie? && self.creature == Zombie::ORIGINAL
  end

  def squad_leader?
    if squadron
      return true
    elsif self.squad.highest_ranking == self
      return true
    else
      return false
    end
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

  def is_expired
    return self.zombie_expires_at < Time.now unless self.creature.immortal
  end

  def zombification_event
    self.bitten_events.first
  end

  def format_user_number
    generate_user_number unless self.user_number
    self.user_number = Codeinator.format_code(self.user_number)
  end

  def set_zombie_expires_at
    if Time.now < self.game.start_at
      time = self.game.start_at
    else
      time = Time.now
    end
    self.zombie_expires_at = time + self.game.time_per_food.seconds unless self.zombie_expires_at || !self.mortal?
  end

  def generate_user_number
    self.user_number = Digest::SHA1.hexdigest(rand.to_s + "HVZ RAWKS!!!" + Time.now.to_s)[0, 10]
  end

  def record_pseudo_bite(pseudo_bite)
    return false if pseudo_bite.used? || dead?
    time_increase = Time.now + self.game.time_per_food
    self.zombie_expires_at = Time.now + self.game.time_per_food unless time_increase < self.zombie_expires_at
    pseudo_bite_event = PseudoBiteEvent.new :pseudo_bite => pseudo_bite, :zombie_participation => self, :zombie_expiration_calculation => self.zombie_expires_at
    create_bite_shares(pseudo_bite_event)
    pseudo_bite_event.save
    pseudo_bite.used = true
    pseudo_bite.save
    return save
  end

  def record_bite(game_participation)
    return false if dead?
    BiteReporter.record_bite(self, game_participation)
    return true
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

  def set_to_human_if_not_set
    self.creature = Human::NORMAL unless self.creature_type && self.creature_id
  end
end
