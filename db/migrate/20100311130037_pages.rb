class Pages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.references :parent
      t.string :name
      t.string :title
      t.text :description
      t.boolean :displayed_in_menu, :default=>true
      t.integer :position
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end