class CreateSarcasticComments < ActiveRecord::Migration
  def self.up
    create_table :sarcastic_comments do |t|
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :sarcastic_comments
  end
end
