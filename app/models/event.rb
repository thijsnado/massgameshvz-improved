class Event < ActiveRecord::Base
  belongs_to :game_participation
  belongs_to :target_object, :polymorphic => true
end
