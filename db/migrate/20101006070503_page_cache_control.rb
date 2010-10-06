class PageCacheControl < ActiveRecord::Migration
  def self.up
    add_column :pages, :always_refresh, :boolean, :default => false, :after => :refresh_scheduled_at
  end
  
  def self.down
    remove_column :pages, :always_refresh
  end 
end