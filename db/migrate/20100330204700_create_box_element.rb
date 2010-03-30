class CreateBoxElement < ActiveRecord::Migration
  def self.up
    create_table :elements_box_elements do |t|
      t.timestamps
    end
    Humpyard::Elements::BoxElement.create_translation_table! :title => :string
    drop_table :elements_container_elements
  end
  
  def self.down
    Humpyard::Elements::BoxElement.drop_translation_table!
    drop_table :elements_box_elements
    create_table :elements_container_elements do |t|
      t.timestamps
    end
  end 
end
