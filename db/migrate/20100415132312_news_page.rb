class NewsPage < ActiveRecord::Migration
  def self.up
    #Remove old news stuff if exists
    # begin
    #   drop_table :news_feed_translations
    # rescue
    # end
    # begin
    #   drop_table :news_feeds
    # rescue
    # end
    # begin
    #   drop_table :news_item_translations
    # rescue
    # end
    # begin
    #   drop_table :news_items
    # rescue
    # end    
    
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
    
    create_table :news_item_translations do |t|
      t.references :"#{Humpyard::config.table_name_prefix}news_items"
      t.string :locale
      t.string :title
      t.string :title_for_url 
      t.text :description 
      t.timestamps
    end
  end

  def self.down
    drop_table :news_item_translations
    drop_table :news_items
    drop_table :pages_news_pages
  end
end