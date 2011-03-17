class CreateSquads < ActiveRecord::Migration
  def self.up
    create_table :squads do |t|
      t.string :squad_name
      t.references :squad_leader

      t.timestamps
    end
  end

  def self.down
    drop_table :squads
  end
end
