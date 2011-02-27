class BiteEvent < Event
  attr_accessor :human_code
  attr_accessor :zombie_code
  
  belongs_to :biter_participation, :class_name => 'GameParticipation', :foreign_key => :responsible_object_id
  belongs_to :bitten_participation, :class_name => 'GameParticipation', :foreign_key => :game_participation_id
  has_many :bite_shares
end
