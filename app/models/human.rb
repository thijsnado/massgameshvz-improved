class Human < ActiveRecord::Base
  has_many :game_participations, :as => :creature
  
  def human?
    true
  end
  
  def zombie?
    false
  end
  
  #using this to dynamically set default zombie types, if we
  #set them the traditional way, they will try to find the zombies
  #in the db before they have been loaded in the db
  def self.const_missing(name)
    case name
    when :NORMAL
      const_set(:NORMAL, find_by_code(:normal))
    when :SQUAD
      const_set(:SQUAD, find_by_code(:squad))
    end
  end
end
