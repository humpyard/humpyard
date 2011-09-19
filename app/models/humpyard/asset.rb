module Humpyard
  class Asset < ::ActiveRecord::Base
    attr_accessible :width, :height
    attr_accessible :content_data, :content_data_id, :content_data_type
    
    belongs_to :content_data, polymorphic: true, dependent: :destroy  
    
    set_table_name "#{Humpyard::config.table_name_prefix}assets"
    
    delegate :url, :content_type, to: :content_data
    
    def title
      self[:title] ||= content_data.try(:asset_name)
    end
    
    def versions
      content_data.try(:versions) || {
        original: [width, height]
      }
    end
  end
end
