class Humpyard::Assets::CarrierwaveAsset < ActiveRecord::Base
  attr_accessible :file

  acts_as_humpyard_asset system_asset: true
  
  mount_uploader :file, Humpyard::AssetUploader

  def url(version = :original)
    file.url(version.try(:to_sym) == :original ? nil : version)
  end
  
  def versions options = {}
    return {original: nil} unless asset.width.to_i > 0 and asset.height.to_i > 0
    
    res = {
      original: [asset.width, asset.height],
      icon: [32, 32]
    }
    
    Humpyard::config.asset_carrierwave_image_versions.each do |k,v|
      dest_width = v[1]
      dest_height = v[2]
      scale_method = v.first.to_sym
      
      if scale_method == :fill
        res[k.to_sym] = [dest_width, dest_height]
      elsif [:fit, :limit].include? scale_method
        scale = [dest_width.to_f / asset.width,  dest_height.to_f / asset.height].min
        
        if scale > 1 and scale_method == :limit
          if options[:include_duplicates]
            res[k.to_sym] = [asset.width, asset.height]
          end
        else
          res[k.to_sym] = [(scale * asset.width).round, (scale * asset.height).round]
        end
      end
    end
    
    return res
  end
  
  def icon
    url(:icon) if versions[:icon]
  end
  
  def image_size_of(version)
    versions(include_duplicates: true)[version.try(:to_sym)] || [asset.width, asset.height]
  end
end
