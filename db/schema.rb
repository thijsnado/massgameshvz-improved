# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110328000647) do

  create_table "bite_shares", :force => true do |t|
    t.integer  "bite_event_id"
    t.boolean  "used",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shared_with_id"
  end

  add_index "bite_shares", ["bite_event_id"], :name => "index_bite_shares_on_bite_event_id"

  create_table "email_domains", :force => true do |t|
    t.string   "description"
    t.string   "rule"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "game_participation_id"
    t.string   "type"
    t.datetime "occured_at"
    t.datetime "zombie_expiration_calculation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "target_object_type"
    t.integer  "target_object_id"
  end

  add_index "events", ["game_participation_id"], :name => "index_events_on_game_participation_id"
  add_index "events", ["target_object_type", "target_object_id"], :name => "index_events_on_target_object_type_and_target_object_id"

  create_table "game_participations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "living_area_id"
    t.string   "user_number"
    t.integer  "creature_id"
    t.string   "creature_type"
    t.datetime "zombie_expires_at"
    t.integer  "zombie_parent_id"
    t.boolean  "original_zombie_request", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "squad_id"
    t.integer  "rank"
  end

  add_index "game_participations", ["creature_type", "creature_id"], :name => "index_game_participations_on_creature_type_and_creature_id"
  add_index "game_participations", ["living_area_id"], :name => "index_game_participations_on_living_area_id"
  add_index "game_participations", ["squad_id"], :name => "index_game_participations_on_squad_id"
  add_index "game_participations", ["user_id"], :name => "index_game_participations_on_user_id"
  add_index "game_participations", ["user_number"], :name => "index_game_participations_on_user_number"

  create_table "games", :force => true do |t|
    t.string   "game_name"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "signup_start_at"
    t.datetime "signup_end_at"
    t.integer  "time_per_food"
    t.integer  "bite_shares_per_food"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "pause_starts_at"
    t.datetime "pause_ends_at"
  end

  create_table "humans", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.boolean  "immortal_when_bitten"
    t.string   "color_string"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "humans", ["code"], :name => "index_humans_on_code"

  create_table "living_areas", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.text     "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pseudo_bites", :force => true do |t|
    t.string   "code"
    t.datetime "valid_after"
    t.integer  "game_participation_id"
    t.boolean  "used",                  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
  end

  add_index "pseudo_bites", ["code"], :name => "index_pseudo_bites_on_code"

  create_table "sarcastic_comments", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "squads", :force => true do |t|
    t.string   "squad_name"
    t.integer  "squad_leader_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "squads", ["squad_leader_id"], :name => "index_squads_on_squad_leader_id"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "email_address"
    t.string   "phone"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "confirmation_hash"
    t.boolean  "confirmed",         :default => false
    t.boolean  "is_admin",          :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "vaccines", :force => true do |t|
    t.string   "code"
    t.datetime "valid_after"
    t.boolean  "used",        :default => false
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vaccines", ["code"], :name => "index_vaccines_on_code"

  create_table "zombies", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.boolean  "vaccinatable"
    t.boolean  "immortal"
    t.string   "color_string"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "zombies", ["code"], :name => "index_zombies_on_code"

end
