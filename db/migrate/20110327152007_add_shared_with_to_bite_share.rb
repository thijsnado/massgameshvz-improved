class AddSharedWithToBiteShare < ActiveRecord::Migration
  def self.up
    add_column :bite_shares, :shared_with_id, :integer
  end

  def self.down
    remove_column :bite_shares, :shared_with_id
  end
end
