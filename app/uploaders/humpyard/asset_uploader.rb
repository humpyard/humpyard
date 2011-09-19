# encoding: utf-8

module Humpyard
  class AssetUploader < ::CarrierWave::Uploader::Base
    include Humpyard::config.asset_carrierwave_image_processor if Humpyard::config.asset_carrierwave_image_processor

    storage :file
    # storage :fog

    def store_dir
      "humpyard/uploads/#{model.id}"
    end
    
    def filename
      model.name || File.basename(to_s)
    end
    
    if Humpyard::config.asset_carrierwave_image_processor
      Humpyard::config.asset_carrierwave_image_versions.each do |name, process_params|
        version name, if: :sizeable? do
          input_params = process_params.clone
          cw_params = {}
          cw_params["resize_to_#{input_params.shift}"] = input_params
          process cw_params
        end
      end
    end

    process :detect_file_meta
    def detect_file_meta
       model.name = File.basename to_s
       model.size = size
       model.content_type = file.content_type
       model.width, model.height = `identify -format "%wx %h" #{file.path}`.split(/x/)
    end
    
    def sizeable?(new_file)
      new_file.content_type =~ /^image/
    end
  end
end