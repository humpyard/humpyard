class Humpyard::Assets::CarrierwaveAsset < ActiveRecord::Base
  attr_accessible :file

  acts_as_humpyard_asset system_asset: true
  
  mount_uploader :file, Humpyard::AssetUploader

  def url(version = :original)
    file.url(version.to_sym == :original ? nil : version)
  end
  
  def versions options = {}
    res = {
      original: [asset.width, asset.height]
    }
    
    Humpyard::config.asset_carrierwave_image_versions.each do |k,v|
      dest_width = v[1]
      dest_height = v[2]
      scale_method = v.first.to_sym
      
      if scale_method == :fill
        res[k] = [dest_width, dest_height]
      elsif [:fit, :limit].include? scale_method
        scale = [dest_width.to_f / asset.width,  dest_height.to_f / asset.height].min
        
        if scale > 1 and scale_method == :limit
          if options[:include_duplicates]
            res[k] = [asset.width, asset.height]
          end
        else
          res[k] = [(scale * asset.width).round, (scale * asset.height).round]
        end
      else
        res[k] = [nil, nil]
      end
    end
    
    return res
  end
  
end
