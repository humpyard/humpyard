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
      File.basename to_s
    end
    
    if Humpyard::config.asset_carrierwave_image_processor
      Humpyard::config.asset_carrierwave_image_versions.each do |name, process_params|
        version name do
          cwparams = {}
          cwparams["resize_to_#{process_params.shift}"] = process_params
          process cwparams
        end
      end
    end

    process :detect_file_meta
    def detect_file_meta
       model.name = filename
       model.size = size
       model.content_type = file.content_type
    end
  end
end