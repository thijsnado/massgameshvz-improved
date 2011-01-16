class CreateEmailDomains < ActiveRecord::Migration
  def self.up
    create_table :email_domains do |t|
      t.string :description
      t.string :rule

      t.timestamps
    end
  end

  def self.down
    drop_table :email_domains
  end
end
