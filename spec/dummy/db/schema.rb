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

ActiveRecord::Schema.define(:version => 20110629151515) do

  create_table "agents", :force => true do |t|
    t.integer "requests_count"
    t.integer "sessions_count"
    t.string  "request_header"
    t.integer "agent_class_id"
    t.string  "name"
    t.string  "full_version"
    t.string  "major_version"
    t.string  "engine_name"
    t.string  "engine_version"
    t.string  "os"
  end

  add_index "agents", ["agent_class_id"], :name => "index_agents_on_agent_class_id"
  add_index "agents", ["engine_name"], :name => "index_agents_on_engine_name"
  add_index "agents", ["engine_version"], :name => "index_agents_on_engine_version"
  add_index "agents", ["full_version"], :name => "index_agents_on_full_version"
  add_index "agents", ["major_version"], :name => "index_agents_on_major_version"
  add_index "agents", ["name"], :name => "index_agents_on_name"
  add_index "agents", ["os"], :name => "index_agents_on_os"
  add_index "agents", ["request_header"], :name => "index_agents_on_request_header"

  create_table "assets", :force => true do |t|
    t.string   "title"
    t.integer  "width"
    t.integer  "height"
    t.integer  "content_data_id"
    t.string   "content_data_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets_paperclip_assets", :force => true do |t|
    t.string   "media_file_name"
    t.integer  "media_file_size"
    t.string   "media_content_type"
    t.datetime "media_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets_youtube_assets", :force => true do |t|
    t.string   "youtube_video_id"
    t.string   "youtube_title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "elements", :force => true do |t|
    t.integer  "page_id"
    t.integer  "container_id"
    t.integer  "content_data_id"
    t.string   "content_data_type"
    t.datetime "display_from"
    t.datetime "display_until"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "page_yield_name",   :default => "main"
    t.integer  "shared_state"
  end

  add_index "elements", ["page_yield_name"], :name => "index_elements_on_page_yield_name"

  create_table "elements_box_element_translations", :force => true do |t|
    t.integer  "humpyard_elements_box_element_id"
    t.string   "locale"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "elements_box_elements", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "elements_media_elements", :force => true do |t|
    t.integer  "asset_id"
    t.string   "float"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uri"
  end

  create_table "elements_news_elements", :force => true do |t|
    t.integer  "news_page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "elements_sitemap_elements", :force => true do |t|
    t.integer  "levels"
    t.boolean  "show_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "elements_text_element_translations", :force => true do |t|
    t.integer  "humpyard_elements_text_element_id"
    t.string   "locale"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "elements_text_elements", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gricer_agents", :force => true do |t|
    t.integer "requests_count"
    t.integer "sessions_count"
    t.string  "request_header"
    t.integer "agent_class_id"
    t.string  "name"
    t.string  "full_version"
    t.string  "major_version"
    t.string  "engine_name"
    t.string  "engine_version"
    t.string  "os"
  end

  add_index "gricer_agents", ["agent_class_id"], :name => "index_gricer_agents_on_agent_class_id"
  add_index "gricer_agents", ["engine_name"], :name => "index_gricer_agents_on_engine_name"
  add_index "gricer_agents", ["engine_version"], :name => "index_gricer_agents_on_engine_version"
  add_index "gricer_agents", ["full_version"], :name => "index_gricer_agents_on_full_version"
  add_index "gricer_agents", ["major_version"], :name => "index_gricer_agents_on_major_version"
  add_index "gricer_agents", ["name"], :name => "index_gricer_agents_on_name"
  add_index "gricer_agents", ["os"], :name => "index_gricer_agents_on_os"
  add_index "gricer_agents", ["request_header"], :name => "index_gricer_agents_on_request_header"

  create_table "gricer_requests", :force => true do |t|
    t.integer  "session_id"
    t.integer  "agent_id"
    t.string   "host"
    t.string   "path"
    t.string   "method"
    t.string   "protocol"
    t.string   "controller"
    t.string   "action"
    t.string   "format"
    t.string   "param_id"
    t.integer  "user_id"
    t.integer  "status_code"
    t.string   "content_type"
    t.integer  "body_size"
    t.integer  "system_time"
    t.integer  "user_time"
    t.integer  "total_time"
    t.integer  "real_time"
    t.boolean  "javascript"
    t.integer  "window_width"
    t.integer  "window_height"
    t.string   "referer_protocol"
    t.string   "referer_host"
    t.string   "referer_path"
    t.text     "referer_params"
    t.string   "search_engine"
    t.string   "search_query"
    t.boolean  "is_first_in_session"
    t.string   "locale_major",        :limit => 2
    t.string   "locale_minor",        :limit => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gricer_requests", ["agent_id"], :name => "index_gricer_requests_on_agent_id"
  add_index "gricer_requests", ["javascript"], :name => "index_gricer_requests_on_javascript"
  add_index "gricer_requests", ["path"], :name => "index_gricer_requests_on_path"
  add_index "gricer_requests", ["referer_host"], :name => "index_gricer_requests_on_referer_host"
  add_index "gricer_requests", ["search_engine"], :name => "index_gricer_requests_on_search_engine"
  add_index "gricer_requests", ["search_query"], :name => "index_gricer_requests_on_search_query"
  add_index "gricer_requests", ["session_id"], :name => "index_gricer_requests_on_session_id"
  add_index "gricer_requests", ["window_height"], :name => "index_gricer_requests_on_window_height"
  add_index "gricer_requests", ["window_width"], :name => "index_gricer_requests_on_window_width"

  create_table "gricer_schema_migrations", :id => false, :force => true do |t|
    t.string "version", :null => false
  end

  add_index "gricer_schema_migrations", ["version"], :name => "gricer_unique_schema_migrations", :unique => true

  create_table "gricer_sessions", :force => true do |t|
    t.integer  "previous_session_id"
    t.integer  "agent_id"
    t.integer  "requests_count"
    t.string   "ip_address_hash"
    t.string   "domain"
    t.string   "country",                   :limit => 2
    t.string   "region"
    t.string   "city"
    t.string   "postal_code"
    t.float    "longitude"
    t.float    "latitude"
    t.boolean  "javascript",                             :default => false
    t.boolean  "java"
    t.string   "flash_version"
    t.string   "flash_major_version"
    t.string   "silverlight_version"
    t.string   "silverlight_major_version"
    t.integer  "screen_width"
    t.integer  "screen_height"
    t.string   "screen_size"
    t.integer  "screen_depth"
    t.string   "requested_locale_major",    :limit => 2
    t.string   "requested_locale_minor",    :limit => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gricer_sessions", ["agent_id"], :name => "index_gricer_sessions_on_agent_id"
  add_index "gricer_sessions", ["city"], :name => "index_gricer_sessions_on_city"
  add_index "gricer_sessions", ["country"], :name => "index_gricer_sessions_on_country"
  add_index "gricer_sessions", ["flash_major_version"], :name => "index_gricer_sessions_on_flash_major_version"
  add_index "gricer_sessions", ["flash_version"], :name => "index_gricer_sessions_on_flash_version"
  add_index "gricer_sessions", ["ip_address_hash"], :name => "index_gricer_sessions_on_ip_address_hash"
  add_index "gricer_sessions", ["java"], :name => "index_gricer_sessions_on_java"
  add_index "gricer_sessions", ["javascript"], :name => "index_gricer_sessions_on_javascript"
  add_index "gricer_sessions", ["screen_depth"], :name => "index_gricer_sessions_on_screen_depth"
  add_index "gricer_sessions", ["screen_height"], :name => "index_gricer_sessions_on_screen_height"
  add_index "gricer_sessions", ["screen_size"], :name => "index_gricer_sessions_on_screen_size"
  add_index "gricer_sessions", ["screen_width"], :name => "index_gricer_sessions_on_screen_width"
  add_index "gricer_sessions", ["silverlight_major_version"], :name => "index_gricer_sessions_on_silverlight_major_version"
  add_index "gricer_sessions", ["silverlight_version"], :name => "index_gricer_sessions_on_silverlight_version"

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
    t.datetime "display_from"
    t.datetime "display_until"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "page_yield_name",   :default => "main"
    t.integer  "shared_state"
  end

  add_index "humpyard_elements", ["page_yield_name"], :name => "index_humpyard_elements_on_page_yield_name"

  create_table "humpyard_elements_box_element_translations", :force => true do |t|
    t.integer  "humpyard_elements_box_element_id"
    t.string   "locale"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "humpyard_elements_box_elements", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "humpyard_elements_media_elements", :force => true do |t|
    t.integer  "asset_id"
    t.string   "float"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uri"
  end

  create_table "humpyard_elements_news_elements", :force => true do |t|
    t.integer  "news_page_id"
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

  create_table "humpyard_news_item_translations", :force => true do |t|
    t.integer  "humpyard_news_items_id"
    t.string   "locale"
    t.string   "title"
    t.string   "title_for_url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "humpyard_news_items", :force => true do |t|
    t.integer  "news_page_id"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
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
    t.boolean  "in_menu",              :default => true
    t.boolean  "in_sitemap",           :default => true
    t.boolean  "searchable",           :default => true
    t.datetime "display_from"
    t.datetime "display_until"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "template_name",        :default => "application"
    t.integer  "content_data_id"
    t.string   "content_data_type"
    t.datetime "modified_at"
    t.datetime "refresh_scheduled_at"
    t.boolean  "always_refresh",       :default => false
  end

  create_table "humpyard_pages_news_pages", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "news_item_translations", :force => true do |t|
    t.integer  "humpyard_news_items_id"
    t.string   "locale"
    t.string   "title"
    t.string   "title_for_url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_items", :force => true do |t|
    t.integer  "news_page_id"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "page_translations", :force => true do |t|
    t.integer  "humpyard_page_id"
    t.string   "locale"
    t.string   "title"
    t.string   "title_for_url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.boolean  "in_menu",              :default => true
    t.boolean  "in_sitemap",           :default => true
    t.boolean  "searchable",           :default => true
    t.datetime "display_from"
    t.datetime "display_until"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "template_name",        :default => "application"
    t.integer  "content_data_id"
    t.string   "content_data_type"
    t.datetime "modified_at"
    t.datetime "refresh_scheduled_at"
    t.boolean  "always_refresh",       :default => false
  end

  create_table "pages_news_pages", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "pages_static_pages", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages_virtual_pages", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requests", :force => true do |t|
    t.integer  "session_id"
    t.integer  "agent_id"
    t.string   "host"
    t.string   "path"
    t.string   "method"
    t.string   "protocol"
    t.string   "controller"
    t.string   "action"
    t.string   "format"
    t.string   "param_id"
    t.integer  "user_id"
    t.integer  "status_code"
    t.string   "content_type"
    t.integer  "body_size"
    t.integer  "system_time"
    t.integer  "user_time"
    t.integer  "total_time"
    t.integer  "real_time"
    t.boolean  "javascript"
    t.integer  "window_width"
    t.integer  "window_height"
    t.string   "referer_protocol"
    t.string   "referer_host"
    t.string   "referer_path"
    t.text     "referer_params"
    t.string   "search_engine"
    t.string   "search_query"
    t.boolean  "is_first_in_session"
    t.string   "locale_major",        :limit => 2
    t.string   "locale_minor",        :limit => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "requests", ["agent_id"], :name => "index_requests_on_agent_id"
  add_index "requests", ["javascript"], :name => "index_requests_on_javascript"
  add_index "requests", ["path"], :name => "index_requests_on_path"
  add_index "requests", ["referer_host"], :name => "index_requests_on_referer_host"
  add_index "requests", ["search_engine"], :name => "index_requests_on_search_engine"
  add_index "requests", ["search_query"], :name => "index_requests_on_search_query"
  add_index "requests", ["session_id"], :name => "index_requests_on_session_id"
  add_index "requests", ["window_height"], :name => "index_requests_on_window_height"
  add_index "requests", ["window_width"], :name => "index_requests_on_window_width"

  create_table "sessions", :force => true do |t|
    t.integer  "previous_session_id"
    t.integer  "agent_id"
    t.integer  "requests_count"
    t.string   "ip_address_hash"
    t.string   "domain"
    t.string   "country",                   :limit => 2
    t.string   "region"
    t.string   "city"
    t.string   "postal_code"
    t.float    "longitude"
    t.float    "latitude"
    t.boolean  "javascript",                             :default => false
    t.boolean  "java"
    t.string   "flash_version"
    t.string   "flash_major_version"
    t.string   "silverlight_version"
    t.string   "silverlight_major_version"
    t.integer  "screen_width"
    t.integer  "screen_height"
    t.string   "screen_size"
    t.integer  "screen_depth"
    t.string   "requested_locale_major",    :limit => 2
    t.string   "requested_locale_minor",    :limit => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["agent_id"], :name => "index_sessions_on_agent_id"
  add_index "sessions", ["city"], :name => "index_sessions_on_city"
  add_index "sessions", ["country"], :name => "index_sessions_on_country"
  add_index "sessions", ["flash_major_version"], :name => "index_sessions_on_flash_major_version"
  add_index "sessions", ["flash_version"], :name => "index_sessions_on_flash_version"
  add_index "sessions", ["ip_address_hash"], :name => "index_sessions_on_ip_address_hash"
  add_index "sessions", ["java"], :name => "index_sessions_on_java"
  add_index "sessions", ["javascript"], :name => "index_sessions_on_javascript"
  add_index "sessions", ["screen_depth"], :name => "index_sessions_on_screen_depth"
  add_index "sessions", ["screen_height"], :name => "index_sessions_on_screen_height"
  add_index "sessions", ["screen_size"], :name => "index_sessions_on_screen_size"
  add_index "sessions", ["screen_width"], :name => "index_sessions_on_screen_width"
  add_index "sessions", ["silverlight_major_version"], :name => "index_sessions_on_silverlight_major_version"
  add_index "sessions", ["silverlight_version"], :name => "index_sessions_on_silverlight_version"

end
