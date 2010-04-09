class News < ActiveRecord::Migration
  def self.up
    create_table :news_feeds do |t|
      t.string :name
      t.timestamps
      t.datetime :deleted_at
    end
    Humpyard::NewsFeed.create_translation_table! :title => :string, :description => :text
    Humpyard::NewsFeed.reset_column_information
    
    create_table :news_items do |t|
      t.references :news_feed
      t.datetime :published_at
      t.timestamps
      t.datetime :deleted_at
    end
    Humpyard::NewsItem.create_translation_table! :title => :string, :content => :text
    Humpyard::NewsItem.reset_column_information
  end

  def self.down
    Humpyard::Elements::NewsItem.drop_translation_table!
    Humpyard::Elements::NewsFeed.drop_translation_table!
    drop_table :news_feeds
    drop_table :news_items
  end
end