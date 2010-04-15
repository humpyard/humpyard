class CreateNewsElement < ActiveRecord::Migration
  def self.up
    create_table :elements_news_elements do |t|
      t.references :news_page
      t.timestamps
    end
  end
  
  def self.down
    drop_table :elements_news_elements
  end 
end
