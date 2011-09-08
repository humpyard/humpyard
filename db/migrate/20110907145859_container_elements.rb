class ContainerElements < ActiveRecord::Migration
  def change
    create_table :elements_container_elements do |t|
      t.string :preset
      t.timestamps
    end
    
    create_table :elements_container_element_translations do |t|
      t.references :"#{Humpyard::config.table_name_prefix}elements_container_element"
      t.string :locale
      t.string :title
      t.timestamps
    end
    
    add_column :elements, :container_slot, :integer, default: 0, after: :container_id
  end
end
