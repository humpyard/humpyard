class PageModifiedAt < ActiveRecord::Migration
  def self.up
    add_column :pages, :modified_at, :datetime, :after => :updated_at
    add_column :pages, :refresh_scheduled_at, :datetime, :after => :modified_at
  end
  
  def self.down
    remove_column :pages, :modified_at
    remove_column :pages, :refresh_scheduled_at
  end 
end