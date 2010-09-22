class Base < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.references :parent
      t.string :name  # should be i18n, searchable
      t.boolean :in_menu, :default => true
      t.boolean :in_sitemap, :default => true
      t.boolean :searchable, :default => true
      t.datetime :display_from
      t.datetime :display_until
      t.integer :position
      t.timestamps
      t.datetime :deleted_at
    end
    
    create_table :page_translations do |t|
      t.references :"#{Humpyard::config.table_name_prefix}page"
      t.string :locale
      t.string :title
      t.string :title_for_url 
      t.text :description 
      t.timestamps
    end
    
    create_table :elements do |t|
      t.references :page
      t.references :container
      t.references :content_data
      t.string :content_data_type
      t.datetime :display_from
      t.datetime :display_until
      t.integer :position
      t.timestamps
      t.datetime :deleted_at
    end
    
    create_table :elements_container_elements do |t|
      t.timestamps
    end
    
    create_table :elements_text_elements do |t|
      t.timestamps
    end
    
    create_table :elements_text_element_translations do |t|
      t.references :"#{Humpyard::config.table_name_prefix}elements_text_element"
      t.text :text 
      t.timestamps
    end
  end

  def self.down
    drop_table :elements_text_element_translations
    drop_table :elements_text_element
    drop_table :elements
    drop_table :page_translations
    drop_table :pages
  end
end