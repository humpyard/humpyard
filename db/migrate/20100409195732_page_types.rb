class PageTypes < ActiveRecord::Migration
  def self.up
    add_column :pages, :content_data_id, :integer
    add_column :pages, :content_data_type, :string
    Humpyard::Page.reset_column_information
    
    create_table :pages_static_pages do |t|
      t.timestamps
    end
    Humpyard::Page.all.each do |p|
      Humpyard::Pages::StaticPage.create :page => p
    end
    
  end
  
  def self.down
    drop_table :pages_static_pages 
    remove_column :pages, :content_data_id
    remove_column :pages, :content_data_type
    Humpyard::Page.reset_column_information
  end 
end
