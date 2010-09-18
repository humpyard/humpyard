class NewsPage < ActiveRecord::Migration
  def self.up
    #Remove old news stuff if exists
    begin
      drop_table :news_feed_translations
    rescue
    end
    begin
      drop_table :news_feeds
    rescue
    end
    begin
      drop_table :news_item_translations
    rescue
    end
    begin
      drop_table :news_items
    rescue
    end    
    
    create_table :pages_news_pages do |t|
      t.timestamps
      t.datetime :deleted_at
    end
        
    create_table :news_items do |t|
      t.references :news_page
      t.datetime :published_at
      t.timestamps
      t.datetime :deleted_at
    end
    Humpyard::NewsItem.create_translation_table! :title => :string, :title_for_url => :string, :content => :text
    begin
      # Workaround for namespace issue
      rename_column :elements_news_element_translations, :elements_news_element_id, :humpyard_elements_news_element_id
    rescue
    end
    Humpyard::NewsItem.reset_column_information
  end

  def self.down
    Humpyard::NewsItem.drop_translation_table!
    drop_table :news_items
    drop_table :pages_news_pages
  end
end