class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :email_address
      t.string :phone
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.string :confirmation_hash
      t.boolean :confirmed, :default => false
      t.boolean :is_admin, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
