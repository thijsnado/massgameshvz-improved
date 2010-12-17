class CreateZombies < ActiveRecord::Migration
  def self.up
    create_table :zombies do |t|
      t.string :name
      t.boolean :vaccinatable
      t.boolean :immortal
      t.string :color_string
      t.timestamps
    end
  end

  def self.down
    drop_table :zombies
  end
end
