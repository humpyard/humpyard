class CreateHumpyardPagesVirtualPages < ActiveRecord::Migration
  def self.up
    create_table :pages_virtual_pages do |t|
      t.timestamps
    end
  end
  
  def self.down
    drop_table :pages_virtual_pages
  end
end