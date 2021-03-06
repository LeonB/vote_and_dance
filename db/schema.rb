# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091230225502) do

  create_table "albums", :force => true do |t|
    t.string   "title"
    t.integer  "artist_id"
    t.integer  "track_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.string   "name_without_prefix"
    t.string   "prefix"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "playlist_items", :force => true do |t|
    t.integer  "song_id"
    t.integer  "playlist_id"
    t.integer  "position"
    t.boolean  "playing",     :default => false
    t.datetime "played_at"
    t.boolean  "played",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "playlist_items", ["song_id"], :name => "index_playlist_items_on_song_id"

  create_table "playlists", :force => true do |t|
    t.string   "name"
    t.boolean  "default"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "songs", :force => true do |t|
    t.string   "title"
    t.string   "genre"
    t.integer  "artist_id"
    t.integer  "album_id"
    t.string   "location"
    t.integer  "track_number"
    t.string   "duration"
    t.integer  "filesize"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                            :null => false
    t.string   "crypted_password",                 :null => false
    t.string   "password_salt",                    :null => false
    t.string   "persistence_token",                :null => false
    t.integer  "login_count",       :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

  create_table "votes", :force => true do |t|
    t.integer  "playlist_item_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["playlist_item_id", "created_by"], :name => "index_votes_on_playlist_item_id_and_created_by", :unique => true
  add_index "votes", ["playlist_item_id"], :name => "index_votes_on_playlist_item_id"

end
