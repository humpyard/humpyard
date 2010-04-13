class PageTemplate < ActiveRecord::Migration
  def self.up
    add_column :pages, :template_name, :string#, :default => Humpyard::config.default_template_name
    Humpyard::Page.reset_column_information
  end
  
  def self.down
    remove_column :pages, :template_name
    Humpyard::Page.reset_column_information
  end 
end
