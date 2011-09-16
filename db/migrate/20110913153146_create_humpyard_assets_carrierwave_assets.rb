class CreateHumpyardAssetsCarrierwaveAssets < ActiveRecord::Migration
  def change
    create_table :assets_carrierwave_assets do |t|
      t.string     :file
      t.string     :name
      t.integer    :size
      t.string     :content_type
      t.timestamps
    end
  end
end
