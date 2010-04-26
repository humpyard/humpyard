class Create<%= plural_class_name %> < ActiveRecord::Migration  
  def self.up  
    create_table :<%= plural_name %> do |t|  
      t.string :username  
      t.string :email  
      t.boolean :admin, :default => false
      t.string :crypted_password  
      t.string :password_salt  
      t.string :persistence_token  
      t.timestamps  
    end  
  end  
  
  def self.down  
    drop_table :users  
  end  
end