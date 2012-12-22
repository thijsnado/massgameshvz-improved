class CreateLivingAreas < ActiveRecord::Migration
  def self.up
    create_table :living_areas do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :living_areas
  end
end
