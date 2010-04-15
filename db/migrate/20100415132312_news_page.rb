class NewsPage < ActiveRecord::Migration
  def self.up
    #Remove old news if exists
    begin
      drop_table :news_item_translations
    rescue
    end
    begin
      drop_table :news_items
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
    
#    create_table :pages_news_pages do |t|
#      t.timestamps
#      t.datetime :deleted_at
#    end
#    Humpyard::Pages::NewsPage.create_translation_table! :description => :text
        
    create_table :news_items do |t|
      t.references :news_page
      t.datetime :published_at
      t.timestamps
      t.datetime :deleted_at
    end
    Humpyard::NewsItem.create_translation_table! :title => :string, :title_for_url => :string, :content => :text
    Humpyard::NewsItem.reset_column_information
  end

  def self.down
    Humpyard::NewsItem.drop_translation_table!
    drop_table :news_items
#    Humpyard::Pages::NewsPage.drop_translation_table!
#    drop_table :pages_news_pages
  end
end