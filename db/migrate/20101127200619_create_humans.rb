class CreateHumans < ActiveRecord::Migration
  def self.up
    create_table :humans do |t|
      t.string :code
      t.string :name
      t.boolean :immortal_when_bitten
      t.string :color_string

      t.timestamps
    end
  end

  def self.down
    drop_table :humans
  end
end
