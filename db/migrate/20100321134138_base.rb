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
    Humpyard::Page.create_translation_table! :title => :string, :title_for_url => :string, :description => :text
    
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
    Humpyard::Elements::TextElement.create_translation_table! :content => :text
  end

  def self.down
    Humpyard::Elements::TextElement.drop_translation_table!
    drop_table :elements_text_element
    drop_table :elements
    Humpyard::Page.drop_translation_table!
    drop_table :pages
  end
end