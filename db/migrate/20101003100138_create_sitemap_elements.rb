class CreateSitemapElements < ActiveRecord::Migration
  def self.up
    create_table :elements_sitemap_elements do |t|
      t.integer :levels
      t.boolean :show_description
      t.timestamps
    end
  end
  
  def self.down
    drop_table :elements_sitemap_elements
  end
end