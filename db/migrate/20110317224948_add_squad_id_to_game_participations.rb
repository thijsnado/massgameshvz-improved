class AddSquadIdToGameParticipations < ActiveRecord::Migration
  def self.up
    add_column :game_participations, :squad_id, :integer
  end

  def self.down
    remove_column :game_participations, :squad_id
  end
end
