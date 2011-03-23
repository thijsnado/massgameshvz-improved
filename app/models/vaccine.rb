class Vaccine < ActiveRecord::Base
  before_save :_format_code
  
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
  
  def self.format_code(code)
    if code
      code = code.strip
      code = code.gsub('0', 'o')
      code = code.upcase
    end
    return code
  end
  
  def _format_code
    set_code unless self.code
    self.code = self.class.format_code(self.code)
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
  
  
end
