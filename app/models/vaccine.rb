class Vaccine < ActiveRecord::Base
  before_validation :format_code
  before_save :set_game_id
  
  validates_uniqueness_of :code
  
  def take(game_participation)
    if takable(game_participation)
      game_participation.creature = Human::NORMAL
      game_participation.save
      self.used = true
      VaccinationEvent.create(:occured_at => Time.now, :game_participation => game_participation, :target_object => self)
      return save
    end
  end
  
  def format_code
    set_code_if_not_set
    self.code = Codeinator.format_code(self.code)
  end
  
  private
  
  def takable(game_participation)
    takable = true
    #vaccine cant be used
    takable = takable && !self.used
    #creature must be vaccinatable zombie
    takable = takable && game_participation.creature.vaccinatable rescue false
    return takable
  end
  
  def set_code_if_not_set
    self.code = Digest::SHA1.hexdigest(rand.to_s + "HVZ RAWKS!!!" + Time.now.to_s)[0, 10] if self.code.blank?
  end
  
  def set_game_id
    self.game_id = Game.current.id unless self.game_id || !Game.current
  end
  
end
