class ElementYield < ActiveRecord::Migration
  def self.up
    change_column :pages, :template_name, :string, :default => Humpyard::config.default_template_name
    Humpyard::Page.reset_column_information
    add_column :elements, :page_yield_name, :string, :default => 'main'
    add_index :elements, :page_yield_name
    Humpyard::Element.reset_column_information
  end
  
  def self.down
    remove_column :elements, :page_yield_name
    Humpyard::Element.reset_column_information
  end 
end