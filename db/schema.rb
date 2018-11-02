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

ActiveRecord::Schema.define(version: 2018_11_01_045337) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aspect_visibilities", force: :cascade do |t|
    t.bigint "aspect_id"
    t.string "shareable_type"
    t.bigint "shareable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aspect_id", "shareable_id", "shareable_type"], name: "shareable_and_aspect_id", unique: true
    t.index ["aspect_id"], name: "index_aspect_visibilities_on_aspect_id"
    t.index ["shareable_type", "shareable_id"], name: "index_aspect_visibilities_on_shareable_id_and_shareable_type"
  end

  create_table "aspects", force: :cascade do |t|
    t.string "name", null: false
    t.integer "order_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_aspects_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_aspects_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "text", null: false
    t.string "guid", null: false
    t.bigint "author_id", null: false
    t.string "commentable_type", null: false
    t.bigint "commentable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_comments_on_person_id"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_id_and_commentable_type"
    t.index ["guid"], name: "index_comments_on_guid", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.string "profile_name", null: false
    t.string "guid", null: false
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid"], name: "index_people_on_guid", unique: true
    t.index ["owner_id"], name: "index_people_on_owner_id", unique: true
    t.index ["profile_name"], name: "index_people_on_profile_name", unique: true
  end

  create_table "pictures", force: :cascade do |t|
    t.boolean "public", default: false, null: false
    t.string "guid", null: false
    t.text "text"
    t.text "remote_image_path"
    t.string "remote_image_name"
    t.string "random_string"
    t.string "processed_image"
    t.integer "height"
    t.integer "width"
    t.string "imageable_type"
    t.bigint "imageable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid"], name: "index_pictures_on_guid", unique: true
    t.index ["imageable_type", "imageable_id"], name: "index_pictures_on_imageable_type_and_imageable_id"
  end

  create_table "posts", force: :cascade do |t|
    t.boolean "public", default: false, null: false
    t.string "guid", null: false
    t.text "text"
    t.string "postable_type"
    t.bigint "postable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid"], name: "index_posts_on_guid", unique: true
    t.index ["id", "postable_type", "created_at"], name: "index_posts_on_id_and_postable_type_and_created_at"
    t.index ["postable_type", "postable_id"], name: "index_posts_on_postable_type_and_postable_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "guid", null: false
    t.string "first_name"
    t.string "last_name"
    t.date "birthday"
    t.string "gender"
    t.string "status"
    t.text "bio"
    t.string "professions"
    t.string "company"
    t.string "current_place"
    t.string "native_place"
    t.string "state"
    t.string "country"
    t.bigint "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_name"], name: "index_profiles_on_first_name"
    t.index ["guid"], name: "index_profiles_on_guid", unique: true
    t.index ["last_name"], name: "index_profiles_on_last_name"
    t.index ["person_id"], name: "index_profiles_on_person_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "aspect_visibilities", "aspects"
  add_foreign_key "aspects", "users"
  add_foreign_key "comments", "people", column: "author_id", name: "comments_author_id_fk", on_delete: :cascade
  add_foreign_key "people", "users", column: "owner_id"
  add_foreign_key "profiles", "people"
end
