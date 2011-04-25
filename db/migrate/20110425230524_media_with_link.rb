class MediaWithLink < ActiveRecord::Migration
  def self.up
    add_column :elements_media_elements, :uri, :string, :after => :float
  end
  
  def self.down
    remove_column :elements_media_elements, :uri
  end 
end