class CreateVaccines < ActiveRecord::Migration
  def self.up
    create_table :vaccines do |t|
      t.string   :code
      t.datetime :valid_after
      t.boolean  :used, :default => false
      t.integer :game_id      
      t.datetime :created_at
      t.datetime :updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :vaccines
  end
end
