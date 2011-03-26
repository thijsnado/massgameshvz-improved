class AddRankToGameParticipation < ActiveRecord::Migration
  def self.up
    add_column :game_participations, :rank, :integer
  end

  def self.down
    remove_column :game_participations, :rank
  end
end
