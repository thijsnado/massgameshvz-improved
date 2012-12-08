class GameParticipation
  class BiteReporter
    attr_accessor :zombie, :victim

    def self.record_bite(zombie, victim)
      new(zombie, victim).record_bite
    end

    def initialize(zombie, victim)
      unless zombie.zombie?
        raise ArgumentError.new "First argument must be zombie."
      end
      unless victim.human? || victim.creature == Zombie::SELF_BITTEN
        raise ArgumentError.new "Second argument must be human or self bitten zombie."
      end
      @zombie, @victim = zombie, victim
    end

    def record_bite
      reward_zombie
      zombify_victim
      save_participants
    end

    private

    def reward_zombie
      increment_zombie_expiration_date
      set_zombie_creature_type
    end

    def increment_zombie_expiration_date
      if victim.creature == Zombie::SELF_BITTEN
        zombie.zombie_expires_at = victim.zombification_event.zombie_expiration_calculation
      else
        zombie.zombie_expires_at = time + time_per_food
      end
    end

    def set_zombie_creature_type
      return if victim.zombie?
      return if zombie.immortal?
      if victim.creature.immortal_when_bitten
        if zombie.creature == Zombie::SELF_BITTEN
          zombie.creature = Zombie::IMMORTAL_SELF_BITTEN
        else
          zombie.creature = Zombie::IMMORTAL
        end
      end
    end

    def zombify_victim
      victim.zombie_expires_at = time + time_per_food unless victim.creature == Zombie::SELF_BITTEN
      victim.creature = Zombie::NORMAL
    end

    def save_participants
      zombie.save
      victim.save
    end

    def time_per_food
      Game.current.time_per_food
    end

    def time
      @time ||= Time.now
    end
  end
end
