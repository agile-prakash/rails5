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

ActiveRecord::Schema.define(version: 2018_12_03_093039) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

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

  create_table "authentications", id: :serial, force: :cascade do |t|
    t.integer "provider_id"
    t.integer "user_id"
    t.string "uid"
    t.string "token"
    t.datetime "token_expires_at"
    t.string "username"
    t.text "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id"], name: "index_authentications_on_provider_id"
    t.index ["user_id"], name: "index_authentications_on_user_id"
  end

  create_table "blocks", id: :serial, force: :cascade do |t|
    t.integer "blocking_id", null: false
    t.integer "blocker_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blocker_id", "blocking_id"], name: "index_blocks_on_blocker_id_and_blocking_id", unique: true
    t.index ["blocker_id"], name: "index_blocks_on_blocker_id"
    t.index ["blocking_id"], name: "index_blocks_on_blocking_id"
  end

  create_table "brands", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "info"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "website"
    t.string "phone"
  end

  create_table "brands_services", id: false, force: :cascade do |t|
    t.integer "brand_id"
    t.integer "service_id"
    t.index ["brand_id"], name: "index_brands_services_on_brand_id"
    t.index ["service_id"], name: "index_brands_services_on_service_id"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.integer "parent_id"
    t.string "ancestry"
    t.index ["ancestry"], name: "index_categories_on_ancestry"
  end

  create_table "categories_products", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "product_id"
  end

  create_table "certificates", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "certificates_users", id: false, force: :cascade do |t|
    t.integer "certificate_id"
    t.integer "user_id"
    t.index ["certificate_id"], name: "index_certificates_users_on_certificate_id"
    t.index ["user_id"], name: "index_certificates_users_on_user_id"
  end

  create_table "colors", id: :serial, force: :cascade do |t|
    t.integer "harmony_id"
    t.string "code"
    t.string "start_hex"
    t.string "end_hex"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "blank", default: false
    t.index ["harmony_id"], name: "index_colors_on_harmony_id"
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contacts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "first_name"
    t.string "last_name"
    t.string "company"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.string "photo_url"
    t.string "asset_url"
    t.string "country_code"
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "contacts_posts", id: false, force: :cascade do |t|
    t.integer "contact_id"
    t.integer "post_id"
    t.index ["contact_id"], name: "index_contacts_posts_on_contact_id"
    t.index ["post_id"], name: "index_contacts_posts_on_post_id"
  end

  create_table "conversations", id: :serial, force: :cascade do |t|
    t.integer "sender_id"
    t.string "recipient_ids"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "degrees", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "postion", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 0
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "educations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "year_from"
    t.integer "year_to"
    t.integer "degree_id"
    t.integer "user_id"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["degree_id"], name: "index_educations_on_degree_id"
    t.index ["user_id"], name: "index_educations_on_user_id"
  end

  create_table "emails", id: :serial, force: :cascade do |t|
    t.string "email"
    t.integer "contact_id"
    t.integer "email_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_emails_on_contact_id"
  end

  create_table "experiences", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "experiences_users", id: false, force: :cascade do |t|
    t.integer "experience_id"
    t.integer "user_id"
    t.index ["experience_id"], name: "index_experiences_users_on_experience_id"
    t.index ["user_id"], name: "index_experiences_users_on_user_id"
  end

  create_table "favourites", id: :serial, force: :cascade do |t|
    t.integer "product_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "folios", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_posts", default: 0
    t.index ["user_id"], name: "index_folios_on_user_id"
  end

  create_table "folios_posts", id: false, force: :cascade do |t|
    t.integer "folio_id"
    t.integer "post_id"
    t.index ["folio_id"], name: "index_folios_posts_on_folio_id"
    t.index ["post_id"], name: "index_folios_posts_on_post_id"
  end

  create_table "follows", id: :serial, force: :cascade do |t|
    t.integer "following_id", null: false
    t.integer "follower_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id"], name: "index_follows_on_follower_id"
    t.index ["following_id"], name: "index_follows_on_following_id"
  end

  create_table "formulas", id: :serial, force: :cascade do |t|
    t.integer "post_id"
    t.integer "service_id"
    t.integer "weight"
    t.integer "volume"
    t.integer "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "photo_id"
    t.integer "position_top"
    t.integer "position_left"
    t.integer "label_id"
    t.integer "line_id"
    t.index ["label_id"], name: "index_formulas_on_label_id"
    t.index ["line_id"], name: "index_formulas_on_line_id"
    t.index ["photo_id"], name: "index_formulas_on_photo_id"
    t.index ["post_id"], name: "index_formulas_on_post_id"
    t.index ["service_id"], name: "index_formulas_on_service_id"
  end

  create_table "harmonies", id: :serial, force: :cascade do |t|
    t.integer "line_id"
    t.string "name"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["line_id"], name: "index_harmonies_on_line_id"
  end

  create_table "labels", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "post_id"
    t.integer "position_top"
    t.integer "position_left"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "photo_id"
    t.integer "label_type"
    t.string "url"
    t.string "name"
    t.index ["photo_id"], name: "index_labels_on_photo_id"
    t.index ["post_id"], name: "index_labels_on_post_id"
    t.index ["tag_id"], name: "index_labels_on_tag_id"
  end

  create_table "likes", id: :serial, force: :cascade do |t|
    t.integer "post_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_likes_on_post_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "lines", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "brand_id"
    t.integer "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_lines_on_brand_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.text "body"
    t.integer "conversation_id"
    t.integer "user_id"
    t.integer "post_id"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "photo_asset_url"
    t.string "video_asset_url"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["post_id"], name: "index_messages_on_post_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.text "body"
    t.string "notifiable_type"
    t.integer "notifiable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "like_id"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "offerings", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "category_id"
    t.integer "service_id"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_offerings_on_category_id"
    t.index ["service_id"], name: "index_offerings_on_service_id"
    t.index ["user_id"], name: "index_offerings_on_user_id"
  end

  create_table "phones", id: :serial, force: :cascade do |t|
    t.string "number"
    t.integer "phone_type"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_phones_on_contact_id"
  end

  create_table "photos", id: :serial, force: :cascade do |t|
    t.string "asset_url"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "video_url"
    t.index ["post_id"], name: "index_photos_on_post_id"
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "likes_count", default: 0
    t.integer "comments_count", default: 0
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "posts_products", id: false, force: :cascade do |t|
    t.integer "post_id"
    t.integer "product_id"
  end

  create_table "posts_tags", id: false, force: :cascade do |t|
    t.integer "post_id"
    t.integer "tag_id"
    t.index ["post_id"], name: "index_posts_tags_on_post_id"
    t.index ["tag_id"], name: "index_posts_tags_on_tag_id"
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "tag_id"
    t.string "image_url"
    t.string "link_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cloudinary_url"
    t.integer "quantity"
    t.decimal "price"
    t.integer "favourites_count", default: 0
    t.integer "category_id"
    t.index ["tag_id"], name: "index_products_on_tag_id"
  end

  create_table "providers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "salons", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "info"
    t.text "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "website"
    t.string "phone"
    t.float "latitude"
    t.float "longitude"
  end

  create_table "services", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "brand_id"
    t.index ["brand_id"], name: "index_services_on_brand_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "labels_count"
    t.string "last_photo"
  end

  create_table "treatments", id: :serial, force: :cascade do |t|
    t.integer "color_id"
    t.integer "formula_id"
    t.integer "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["color_id"], name: "index_treatments_on_color_id"
    t.index ["formula_id"], name: "index_treatments_on_formula_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_type"
    t.string "first_name"
    t.string "last_name"
    t.string "avatar_url"
    t.string "avatar_cloudinary_id"
    t.boolean "share_facebook", default: false
    t.boolean "share_twitter", default: false
    t.boolean "share_instagram", default: false
    t.boolean "share_pinterest", default: false
    t.boolean "share_tumblr", default: false
    t.text "prof_desc"
    t.integer "years_exp"
    t.integer "salon_id"
    t.text "career_opportunity"
    t.string "auth_token"
    t.integer "brand_id"
    t.text "description"
    t.string "facebook_token"
    t.string "twitter_token"
    t.string "instagram_token"
    t.string "pinterest_token"
    t.string "default_pinterest_board"
    t.boolean "auto_follow", default: false
    t.string "facebook_id"
    t.string "instagram_id"
    t.boolean "is_admin", default: true
    t.index ["brand_id"], name: "index_users_on_brand_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["salon_id"], name: "index_users_on_salon_id"
  end

  create_table "videos", id: :serial, force: :cascade do |t|
    t.string "asset_url"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_videos_on_post_id"
  end

  add_foreign_key "authentications", "providers"
  add_foreign_key "authentications", "users"
  add_foreign_key "categories_products", "categories", name: "categories_products_category_id_fkey"
  add_foreign_key "categories_products", "products", name: "categories_products_product_id_fkey"
  add_foreign_key "colors", "harmonies"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "contacts", "users"
  add_foreign_key "contacts_posts", "contacts"
  add_foreign_key "contacts_posts", "posts"
  add_foreign_key "educations", "degrees"
  add_foreign_key "educations", "users"
  add_foreign_key "emails", "contacts"
  add_foreign_key "favourites", "products", name: "favourites_product_id_fkey"
  add_foreign_key "favourites", "users", name: "favourites_user_id_fkey"
  add_foreign_key "folios", "users"
  add_foreign_key "formulas", "labels"
  add_foreign_key "formulas", "lines"
  add_foreign_key "formulas", "photos"
  add_foreign_key "formulas", "posts"
  add_foreign_key "formulas", "services"
  add_foreign_key "harmonies", "lines"
  add_foreign_key "labels", "photos"
  add_foreign_key "labels", "posts"
  add_foreign_key "labels", "tags"
  add_foreign_key "likes", "posts"
  add_foreign_key "likes", "users"
  add_foreign_key "lines", "brands"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "posts"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "offerings", "categories"
  add_foreign_key "offerings", "services"
  add_foreign_key "offerings", "users"
  add_foreign_key "phones", "contacts"
  add_foreign_key "photos", "posts"
  add_foreign_key "posts", "users"
  add_foreign_key "posts_products", "posts", name: "products_posts_post_id_fkey"
  add_foreign_key "posts_products", "products", name: "products_posts_product_id_fkey"
  add_foreign_key "products", "tags"
  add_foreign_key "services", "brands"
  add_foreign_key "treatments", "colors"
  add_foreign_key "treatments", "formulas"
  add_foreign_key "users", "brands"
  add_foreign_key "users", "salons"
  add_foreign_key "videos", "posts"
end
