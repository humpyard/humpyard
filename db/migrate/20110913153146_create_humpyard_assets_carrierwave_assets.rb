class CreateHumpyardAssetsCarrierwaveAssets < ActiveRecord::Migration
  def change
    create_table :assets_carrierwave_assets do |t|
      t.string     :file
      t.timestamps
    end
    
    add_column :assets, :size, :integer
    add_column :assets, :content_type, :string
    
    Humpyard::Asset.reset_column_information
    
    Humpyard::Assets::YoutubeAsset.all.each do |a|
      a.asset.update_attributes width: 480, height: 360, title: a.youtube_title, content_type: 'video/youtube'
    end
    Humpyard::Assets::PaperclipAsset.all.each do |a|
      a.asset.update_attributes title: a.media_file_name, content_type: a.media_content_type, size: a.media_file_size
    end
    
    add_column :elements_media_elements, :asset_version, :string, default: nil
  end
end
