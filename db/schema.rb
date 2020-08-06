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

ActiveRecord::Schema.define(version: 2020_08_04_090417) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "backups", force: :cascade do |t|
    t.string "fullpath"
    t.integer "state"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_backups_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "user_id"
    t.bigint "parent_id"
    t.boolean "active", default: true, null: false
    t.boolean "deletable", default: true, null: false
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["slug", "user_id"], name: "index_categories_on_slug_and_user_id", unique: true
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "category_id"
    t.string "title"
    t.text "content"
    t.boolean "favorite"
    t.string "serial_no"
    t.string "images"
    t.integer "sharestate"
    t.string "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_notes_on_category_id"
    t.index ["guid"], name: "index_notes_on_guid", unique: true
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "note_id"
    t.index ["note_id"], name: "index_taggings_on_note_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "firstname"
    t.string "lastname"
    t.string "users"
    t.string "provider"
    t.string "uid"
    t.string "token"
    t.integer "expires_at"
    t.boolean "expires"
    t.string "refresh_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "backups", "users"
  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "categories", "users"
  add_foreign_key "notes", "categories"
  add_foreign_key "notes", "users"
  add_foreign_key "taggings", "notes"
  add_foreign_key "taggings", "tags"
  add_foreign_key "tags", "users"
end
