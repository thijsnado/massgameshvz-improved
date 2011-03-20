class AddGameIdToPseudoBites < ActiveRecord::Migration
  def self.up
    add_column :pseudo_bites, :game_id, :integer
  end

  def self.down
    remove_column :pseudo_bites, :game_id
  end
end
