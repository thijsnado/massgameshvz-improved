class Event < ActiveRecord::Base
  belongs_to :game_participation
  belongs_to :target_object, :polymorphic => true
  
  def self.belongs_to_game_participation(game_participation)
    where(
      "
        events.game_participation_id = ? OR
        (
          events.target_object_type = ? AND
          events.target_object_id = ?
        )
      ", game_participation.id, 'GameParticipation', game_participation.id
    )
  end
end
