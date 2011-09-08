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

ActiveRecord::Schema.define(:version => 0) do

  create_table "humpyard_assets", :force => true do |t|
    t.string   "title"
    t.integer  "width"
    t.integer  "height"
    t.integer  "content_data_id"
    t.string   "content_data_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "humpyard_assets_paperclip_assets", :force => true do |t|
    t.string   "media_file_name"
    t.integer  "media_file_size"
    t.string   "media_content_type"
    t.datetime "media_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "humpyard_assets_youtube_assets", :force => true do |t|
    t.string   "youtube_video_id"
    t.string   "youtube_title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "humpyard_elements", :force => true do |t|
    t.integer  "page_id"
    t.integer  "container_id"
    t.integer  "content_data_id"
    t.string   "content_data_type"
    t.string   "page_yield_name",   :default => "main"
    t.string   "string",            :default => "main"
    t.datetime "display_from"
    t.datetime "display_until"
    t.integer  "position"
    t.integer  "shared_state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "container_slot",    :default => 1
  end

  add_index "humpyard_elements", ["page_yield_name"], :name => "index_humpyard_elements_on_page_yield_name"

  create_table "humpyard_elements_container_element_translations", :force => true do |t|
    t.integer  "humpyard_elements_container_element_id"
    t.string   "locale"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "humpyard_elements_container_elements", :force => true do |t|
    t.string   "preset"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "humpyard_elements_media_elements", :force => true do |t|
    t.integer  "asset_id"
    t.string   "float"
    t.string   "uri"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "humpyard_elements_sitemap_elements", :force => true do |t|
    t.integer  "levels"
    t.boolean  "show_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "humpyard_elements_text_element_translations", :force => true do |t|
    t.integer  "humpyard_elements_text_element_id"
    t.string   "locale"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "humpyard_elements_text_elements", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "humpyard_page_translations", :force => true do |t|
    t.integer  "humpyard_page_id"
    t.string   "locale"
    t.string   "title"
    t.string   "title_for_url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "humpyard_pages", :force => true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.string   "template_name",        :default => "application"
    t.integer  "content_data_id"
    t.string   "content_data_type"
    t.boolean  "in_menu",              :default => true
    t.boolean  "in_sitemap",           :default => true
    t.boolean  "searchable",           :default => true
    t.datetime "display_from"
    t.datetime "display_until"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "modified_at"
    t.datetime "refresh_scheduled_at"
    t.boolean  "always_refresh",       :default => false
    t.datetime "deleted_at"
  end

  create_table "humpyard_pages_static_pages", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "humpyard_pages_virtual_pages", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "humpyard_schema_migrations", :id => false, :force => true do |t|
    t.string "version", :null => false
  end

  add_index "humpyard_schema_migrations", ["version"], :name => "humpyard_unique_schema_migrations", :unique => true

end
