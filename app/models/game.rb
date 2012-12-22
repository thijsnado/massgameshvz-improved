class Game < ActiveRecord::Base
  has_many :game_participations
  has_many :pseudo_bites

  def squads
    Squad.joins(:squad_leader).where("game_participations.game_id = ?", self.id)
  end
  
  def self.current
    return where("? BETWEEN signup_start_at AND end_at", Time.now).first
  end

  def paused?
    return false if pause_starts_at.blank? || pause_ends_at.blank?
    return true if Time.now.between?(pause_starts_at, pause_ends_at)
  end
  
  def unpause_game
    ActiveRecord::Base.transaction do
      return unless paused?
      now_time = Time.now
      difference_in_seconds = self.pause_ends_at - now_time
      game_participations.where(:creature_type => 'Zombie').each do |gp|
        next if gp.immortal? || gp.dead?
        gp.update_attribute :zombie_expires_at, gp.zombie_expires_at - difference_in_seconds
      end
      self.pause_starts_at = nil
      write_attribute(:pause_ends_at, nil)
      save
    end
  end
  
  def pause_ends_at=(time)
    ActiveRecord::Base.transaction do
      now_time = Time.now
      difference_in_seconds = time - now_time
      return if difference_in_seconds < 0
      game_participations.where(:creature_type => 'Zombie').each do |gp|
        next if gp.immortal? || gp.dead?
        gp.update_attribute :zombie_expires_at, gp.zombie_expires_at + difference_in_seconds
      end
      self.pause_starts_at = now_time
      write_attribute(:pause_ends_at, time)
    end
  end
  
  def pause_until(time)
    ActiveRecord::Base.transaction do
      self.pause_ends_at = time
      save
    end
  end
  
  def reward_zombies(hours)
    ActiveRecord::Base.transaction do
      game_participations.where(:creature_type => 'Zombie').each do |gp|
        next if gp.immortal? || gp.dead?
        gp.update_attribute :zombie_expires_at, gp.zombie_expires_at + hours.to_i.hours
      end
    end
  end
  
end
