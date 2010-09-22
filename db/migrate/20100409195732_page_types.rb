class PageTypes < ActiveRecord::Migration
  def self.up
    add_column :pages, :content_data_id, :integer
    add_column :pages, :content_data_type, :string
    Humpyard::Page.reset_column_information
    
    create_table :pages_static_pages do |t|
      t.timestamps
    end
    
    rename_column :page_translations, :"#{Humpyard::config.table_name_prefix}page_id", :page_id
    Humpyard::Page.all.each do |p|
      sp = Humpyard::Pages::StaticPage.new 
      sp.page = p
      sp.save
    end
    rename_column :page_translations, :page_id, :"#{Humpyard::config.table_name_prefix}page_id"
  end
  
  def self.down
    drop_table :pages_static_pages 
    remove_column :pages, :content_data_id
    remove_column :pages, :content_data_type
    Humpyard::Page.reset_column_information
  end 
end
