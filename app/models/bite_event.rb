class BiteEvent < Event
  attr_accessor :human_code
  attr_accessor :zombie_code
  
  belongs_to :biter_participation, :class_name => 'GameParticipation', :foreign_key => :game_participation_id
  has_many :bite_shares
  
  def bitten_participation
    return self.target_object
  end
  
  def bitten_participation=(val)
    self.target_object = val
  end
end
