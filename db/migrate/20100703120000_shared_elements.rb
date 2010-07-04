class SharedElements < ActiveRecord::Migration
  def self.up
    add_column :elements, :shared_state, :integer
  end
  
  def self.down
    remove_column :elements, :shared_state
  end 
end
