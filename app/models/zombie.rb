class Zombie < ActiveRecord::Base
  
  #using this to dynamically set default zombie types, if we
  #set them the traditional way, they will try to find the zombies
  #in the db before they have been loaded in the db
  def self.const_missing(name)
    case name
    when :NORMAL
      const_set(:NORMAL, find_by_code(:normal))
    when :SELF_BITTEN
      const_set(:SELF_BITTEN, find_by_code(:self_bitten))
    when :IMMORTAL
      const_set(:IMMORTAL, find_by_code(:immortal))
    when :ORIGINAL
      const_set(:ORIGINAL, find_by_code(:original))
    end
  end
end
