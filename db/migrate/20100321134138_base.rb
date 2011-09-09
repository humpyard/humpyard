class Base < ActiveRecord::Migration
  def change
    #
    # Pages
    #
    
    create_table :pages do |t|
      t.references :parent
      t.string     :name  # should be i18n, searchable
      t.string     :template_name, :default => Humpyard::config.default_template_name
      t.references :content_data
      t.string     :content_data_type   
      t.boolean    :in_menu, :default => true
      t.boolean    :in_sitemap, :default => true
      t.boolean    :searchable, :default => true
      t.datetime   :display_from
      t.datetime   :display_until
      t.integer    :position
      t.timestamps
      t.datetime   :modified_at
      t.datetime   :refresh_scheduled_at
      t.boolean    :always_refresh, :default => false
      t.datetime   :deleted_at
    end    
    
    create_table :page_translations do |t|
      t.references :"#{Humpyard::config.table_name_prefix}page"
      t.string   :locale
      t.string   :title
      t.string   :title_for_url 
      t.text     :description 
      t.timestamps
    end
    
    create_table :pages_static_pages do |t|
      t.timestamps
    end
    
    create_table :pages_virtual_pages do |t|
      t.timestamps
    end    
    
    #
    # Assets
    #
    
    create_table :assets do |t|
      t.string     :title
      t.integer    :width
      t.integer    :height
      t.references :content_data
      t.string     :content_data_type
      t.timestamps
    end
    
    create_table :assets_paperclip_assets do |t|
      t.string     :media_file_name
      t.integer    :media_file_size
      t.string     :media_content_type
      t.datetime   :media_updated_at
      t.timestamps
    end
    
    create_table :assets_youtube_assets do |t|
      t.string     :youtube_video_id
      t.string     :youtube_title
      t.timestamps
    end
        
    # 
    # Elements
    #    
        
    create_table :elements do |t|
      t.references :page
      t.references :container
      t.references :content_data
      t.string :content_data_type
      t.string :page_yield_name, :string, :default => 'main'
      t.datetime :display_from
      t.datetime :display_until
      t.integer :position
      t.integer :shared_state
      t.timestamps
      t.datetime :deleted_at
    end
    add_index :elements, :page_yield_name
    
    
    create_table :elements_text_elements do |t|
      t.timestamps
    end
    
    create_table :elements_text_element_translations do |t|
      t.references :"#{Humpyard::config.table_name_prefix}elements_text_element"
      t.string :locale
      t.text :content 
      t.timestamps
    end
    
    create_table :elements_sitemap_elements do |t|
      t.integer :levels
      t.boolean :show_description
      t.timestamps
    end
    
    create_table :elements_media_elements do |t|
      t.references :asset
      t.string     :uri
      t.timestamps
    end 
  end
end
