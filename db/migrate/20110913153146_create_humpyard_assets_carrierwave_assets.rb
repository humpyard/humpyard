class CreateHumpyardAssetsCarrierwaveAssets < ActiveRecord::Migration
  def change
    create_table :assets_carrierwave_assets do |t|
      t.string     :file
      t.string     :name
      t.integer    :size
      t.string     :content_type
      t.timestamps
    end
    
    add_column :elements_media_elements, :asset_version, :string, default: nil
  end
end
