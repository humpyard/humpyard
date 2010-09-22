class CreateBoxElement < ActiveRecord::Migration
  def self.up
    create_table :elements_box_elements do |t|
      t.timestamps
    end
    
    create_table :elements_box_element_translations do |t|
      t.references :"#{Humpyard::config.table_name_prefix}elements_box_element"
      t.string :locale
      t.string :title
      t.timestamps
    end
    
    drop_table :elements_container_elements
  end
  
  def self.down
    drop_table :elements_box_element_translations 
    drop_table :elements_box_elements
    create_table :elements_container_elements do |t|
      t.timestamps
    end
  end 
end
