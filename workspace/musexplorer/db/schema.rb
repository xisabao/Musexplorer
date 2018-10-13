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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160121221848) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name",        null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "description"
  end

  create_table "category_posts", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "post_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "category_posts", ["category_id"], name: "index_category_posts_on_category_id", using: :btree
  add_index "category_posts", ["post_id"], name: "index_category_posts_on_post_id", using: :btree

  create_table "composers", force: :cascade do |t|
    t.string   "name",           null: false
    t.text     "description"
    t.string   "wikipedia_link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "country_composers", force: :cascade do |t|
    t.integer  "country_id"
    t.integer  "composer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "era_composers", force: :cascade do |t|
    t.integer  "era_id"
    t.integer  "composer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "eras", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flags", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "description"
    t.string   "reason"
    t.integer  "flaggable_id"
    t.string   "flaggable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instrument_pieces", force: :cascade do |t|
    t.integer  "instrument_id"
    t.integer  "piece_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "instrument_pieces", ["instrument_id"], name: "index_instrument_pieces_on_instrument_id", using: :btree
  add_index "instrument_pieces", ["piece_id"], name: "index_instrument_pieces_on_piece_id", using: :btree

  create_table "instruments", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "piece_posts", force: :cascade do |t|
    t.integer  "piece_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "piece_posts", ["piece_id"], name: "index_piece_posts_on_piece_id", using: :btree
  add_index "piece_posts", ["post_id"], name: "index_piece_posts_on_post_id", using: :btree

  create_table "piece_users", force: :cascade do |t|
    t.integer  "piece_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "piece_users", ["piece_id"], name: "index_piece_users_on_piece_id", using: :btree
  add_index "piece_users", ["user_id"], name: "index_piece_users_on_user_id", using: :btree

  create_table "pieces", force: :cascade do |t|
    t.string   "name",             null: false
    t.integer  "opus"
    t.integer  "level"
    t.integer  "minutes"
    t.boolean  "concerto"
    t.boolean  "solo"
    t.boolean  "free"
    t.string   "sheet_music_link"
    t.text     "youtube_embed"
    t.integer  "composer_id",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title",      null: false
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "sticky"
  end

  create_table "replies", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",     null: false
    t.integer  "piece_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "taggings", ["piece_id"], name: "index_taggings_on_piece_id", using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tips", force: :cascade do |t|
    t.integer  "piece_id",   null: false
    t.integer  "user_id",    null: false
    t.text     "body",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username",                            null: false
    t.integer  "karma"
    t.integer  "role",                   default: 0
    t.integer  "teacher"
    t.text     "description"
    t.string   "location"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votes", force: :cascade do |t|
    t.boolean  "vote"
    t.integer  "user_id"
    t.integer  "votable_id"
    t.string   "votable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "category_posts", "categories"
  add_foreign_key "category_posts", "posts"
  add_foreign_key "instrument_pieces", "instruments"
  add_foreign_key "instrument_pieces", "pieces"
  add_foreign_key "piece_posts", "pieces"
  add_foreign_key "piece_posts", "posts"
  add_foreign_key "piece_users", "pieces"
  add_foreign_key "piece_users", "users"
  add_foreign_key "taggings", "pieces"
  add_foreign_key "taggings", "tags"
end
