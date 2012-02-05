# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20120205150420) do

  create_table "albums", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer  "album_id"
    t.string   "file"
    t.string   "title"
    t.datetime "date_taken"
    t.string   "place_taken"
    t.string   "camera_model"
    t.string   "exposure_time"
    t.text     "f_number"
    t.integer  "views",             :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "iso_speed"
    t.string   "flash"
    t.string   "flength_35mm_film"
  end

  add_index "photos", ["album_id"], :name => "index_photos_on_album_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "hashed_password"
    t.string   "full_name"
    t.string   "email"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo"
  end

end
