class BiteShare < ActiveRecord::Base
  belongs_to :bite_event
  belongs_to :game_participation
end
