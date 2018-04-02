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

ActiveRecord::Schema.define(version: 20180401083307) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fields", force: :cascade do |t|
    t.string "label_name"
    t.string "label_bound"
    t.string "value_bound"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fields_templates", force: :cascade do |t|
    t.bigint "template_id"
    t.bigint "field_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["field_id"], name: "index_fields_templates_on_field_id"
    t.index ["template_id", "field_id"], name: "index_fields_templates_on_template_id_and_field_id", unique: true
    t.index ["template_id"], name: "index_fields_templates_on_template_id"
  end

  create_table "images", force: :cascade do |t|
    t.bigint "upload_id"
    t.string "processed_photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["upload_id"], name: "index_images_on_upload_id"
  end

  create_table "raws", force: :cascade do |t|
    t.bigint "image_id"
    t.string "raw_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["image_id"], name: "index_raws_on_image_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "template_name"
    t.string "sample_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uploads", force: :cascade do |t|
    t.string "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "fields_templates", "fields"
  add_foreign_key "fields_templates", "templates"
  add_foreign_key "images", "uploads"
  add_foreign_key "raws", "images"
end
