class CreatePseudoBites < ActiveRecord::Migration
  def self.up
    create_table :pseudo_bites do |t|
      t.string :code
      t.datetime :valid_after
      t.references :game_participation
      t.boolean :used, :default => false

      t.timestamps
    end
    add_index :pseudo_bites, :code
  end

  def self.down
    drop_table :pseudo_bites
  end
end
