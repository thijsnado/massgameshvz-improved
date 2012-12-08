class GameParticipation
  class BiteReporter
    attr_accessor :zombie, :victim

    def initialize(zombie, victim)
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
      zombie.zombie_expires_at = Time.now + time_per_food
    end

    def set_zombie_creature_type
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
      victim.creature = Zombie::NORMAL
      victim.zombie_expires_at = Time.now + time_per_food
    end

    def save_participants
      zombie.save
      victim.save
    end

    def time_per_food
      Game.current.time_per_food
    end
  end
end
