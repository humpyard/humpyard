module Humpyard
  class Asset < ::ActiveRecord::Base
    attr_accessible :width, :height
    attr_accessible :content_data, :content_data_id, :content_data_type
    
    belongs_to :content_data, polymorphic: true, dependent: :destroy  
    
    set_table_name "#{Humpyard::config.table_name_prefix}assets"
    
    def title
      content_data.title
    end
    
    def url
      content_data.url
    end
    
    def content_type
      content_data.content_type
    end
  end
end
