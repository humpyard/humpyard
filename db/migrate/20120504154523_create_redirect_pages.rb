class CreateRedirectPages < ActiveRecord::Migration
  def self.up
    create_table :pages_redirect_pages do |t|
      t.string :redirect_uri
      t.integer :status_code
      t.timestamps
    end
  end
  
  def self.down
    drop_table :pages_redirect_pages
  end
end