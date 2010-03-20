class Pages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.references :parent
      t.string :name  # should be i18n, searchable
      t.string :title # should be i18n
      t.text :description # should be i18n
      t.boolean :in_menu, :default => true
      t.boolean :in_sitemap, :default => true
      t.boolean :searchable, :default => true
      t.datetime :display_from
      t.datetime :display_until
      t.integer :position
      t.timestamps
      t.datetime :deleted_at
    end
    
    create_table :elements do |t|
      t.references :page
      t.references :parent
      t.datetime :display_from
      t.datetime :display_until
      t.integer :position
      t.timestamps
      t.datetime :deleted_at
    end
  end

  def self.down
    drop_table :elements
    drop_table :pages
  end
end