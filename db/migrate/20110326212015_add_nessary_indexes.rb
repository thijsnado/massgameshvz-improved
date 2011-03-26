class AddNessaryIndexes < ActiveRecord::Migration
  def self.up
    add_index :bite_shares, :bite_event_id
    add_index :events, :game_participation_id
    add_index :events, [:target_object_type, :target_object_id]
    add_index :game_participations, :user_id
    add_index :game_participations, :living_area_id
    add_index :game_participations, :user_number
    add_index :game_participations, [:creature_type, :creature_id]
    add_index :game_participations, :squad_id
    add_index :humans, :code
    add_index :zombies, :code
    add_index :squads, :squad_leader_id
    add_index :users, :username, :unique => true
    add_index :vaccines, :code
  end

  def self.down
    remove_index :bite_shares, :bite_event_id
    remove_index :events, :game_participation_id
    remove_index :events, [:target_object_type, :target_object_id]
    remove_index :game_participations, :user_id
    remove_index :game_participations, :living_area_id
    remove_index :game_participations, :user_number
    remove_index :game_participations, [:creature_type, :creature_id]
    remove_index :game_participations, :squad_id
    remove_index :humans, :code
    remove_index :zombies, :code
    remove_index :squads, :squad_leader_id
    remove_index :users, :username
    remove_index :vaccines, :code
  end
end
