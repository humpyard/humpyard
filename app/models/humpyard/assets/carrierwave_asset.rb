class Humpyard::Assets::CarrierwaveAsset < ActiveRecord::Base
  attr_accessible :file

  acts_as_humpyard_asset system_asset: true
  
  mount_uploader :file, Humpyard::AssetUploader

  def url
    file.url
  end
  
  def title
    name
  end
end
