class AddPauseToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :pause_starts_at, :datetime
    add_column :games, :pause_ends_at, :datetime
  end

  def self.down
    remove_column :games, :pause_starts_at
    remove_column :games, :pause_ends_at
  end
end
