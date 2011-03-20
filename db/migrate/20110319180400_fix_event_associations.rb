class FixEventAssociations < ActiveRecord::Migration
  def self.up
    remove_column :events, :responsible_object_type
    remove_column :events, :responsible_object_id
    add_column :events, :target_object_type, :string
    add_column :events, :target_object_id, :integer
  end

  def self.down
    add_column :events, :responsible_object_type, :string
    add_column :events, :responsible_object_id, :integer
    remove_column :events, :target_object_type
    remove_column :events, :target_object_id
  end
end
