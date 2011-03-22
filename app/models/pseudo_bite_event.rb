class PseudoBiteEvent < BiteEvent
  belongs_to :zombie_participation, :class_name => 'GameParticipation', :foreign_key => :game_participation_id
  
  def pseudo_bite
    return self.target_object
  end
  
  def pseudo_bite=(val)
    self.target_object = val
  end
end