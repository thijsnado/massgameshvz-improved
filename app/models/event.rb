class Event < ActiveRecord::Base
  belongs_to :game_participation
  belongs_to :responsible_object, :polymorphic => true
end
