module Humpyard
  class Asset < ::ActiveRecord::Base
    attr_accessible :width, :height, :size, :title, :content_type
    attr_accessible :content_data, :content_data_id, :content_data_type
    
    belongs_to :content_data, polymorphic: true, dependent: :destroy  
    
    set_table_name "#{Humpyard::config.table_name_prefix}assets"
    
    delegate :url, to: :content_data
    
    def versions
      content_data.try(:versions) || {
        original: [width, height]
      }
    end
    
    def icon
      content_data.try(:icon) || generic_icon
    end
    
    def generic_icon
      return 'icons/32x32/text.png' if content_type =~ /^text/
      return 'icons/32x32/audio.png' if content_type =~ /^audio/
      return 'icons/32x32/video.png' if content_type =~ /^video/
      
      return 'icons/32x32/unknown.png'
    end
  end
end
