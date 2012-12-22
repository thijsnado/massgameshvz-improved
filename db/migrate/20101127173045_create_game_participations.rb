class CreateGameParticipations < ActiveRecord::Migration
  def self.up
    create_table :game_participations do |t|
      t.references :user
      t.references :game
      t.references :living_area
      t.string :user_number
      t.references :creature, :polymorphic => true
      t.datetime :zombie_expires_at, :default => nil
      t.integer  :zombie_parent_id, :default => nil
      t.boolean :original_zombie_request, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :game_participations
  end
end
