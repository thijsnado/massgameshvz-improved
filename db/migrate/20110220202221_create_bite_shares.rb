class CreateBiteShares < ActiveRecord::Migration
  def self.up
    create_table :bite_shares do |t|
      t.belongs_to :bite_event
      t.boolean :used

      t.timestamps
    end
  end

  def self.down
    drop_table :bite_shares
  end
end
