class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.string :game_name
      t.datetime :start_at
      t.datetime :end_at
      t.datetime :signup_start_at
      t.datetime :signup_end_at
      t.integer :time_per_food
      t.integer :bite_shares_per_food

      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
