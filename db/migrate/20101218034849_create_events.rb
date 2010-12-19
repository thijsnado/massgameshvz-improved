class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :responsible_object_id
      t.string :responsible_object_type
      t.integer :game_participation_id
      t.string :type
      t.datetime :occured_at 

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
