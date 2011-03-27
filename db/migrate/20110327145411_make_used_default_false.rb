class MakeUsedDefaultFalse < ActiveRecord::Migration
  def self.up
    change_column :bite_shares, :used, :boolean, :default => false
  end

  def self.down
    change_column :bite_shares, :used, :boolean, :default => nil
  end
end
