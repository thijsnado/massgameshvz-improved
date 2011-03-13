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

ActiveRecord::Schema.define(:version => 20110313163734) do

  create_table "bite_shares", :force => true do |t|
    t.integer  "bite_event_id"
    t.boolean  "used"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_domains", :force => true do |t|
    t.string   "description"
    t.string   "rule"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "responsible_object_id"
    t.string   "responsible_object_type"
    t.integer  "game_participation_id"
    t.string   "type"
    t.datetime "occured_at"
    t.datetime "zombie_expiration_calculation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  end

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
  end

  create_table "humans", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.boolean  "immortal_when_bitten"
    t.string   "color_string"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "living_areas", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sarcastic_comments", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "vaccines", :force => true do |t|
    t.string   "code"
    t.datetime "valid_after"
    t.boolean  "used",        :default => false
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "zombies", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.boolean  "vaccinatable"
    t.boolean  "immortal"
    t.string   "color_string"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
