module Humpyard
  module Elements
    class MediaElement < ::ActiveRecord::Base
      attr_accessible :asset, :asset_id, :asset_version, :uri
      
      set_table_name "#{Humpyard::config.table_name_prefix}elements_media_elements"  
      
      acts_as_humpyard_element
      
      belongs_to :asset, class_name: 'Humpyard::Asset'
   end
 end
end