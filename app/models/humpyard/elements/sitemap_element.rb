module Humpyard
  module Elements
    class SitemapElement < ::ActiveRecord::Base
      set_table_name "#{Humpyard::config.table_name_prefix}elements_sitemap_elements"        
      
      acts_as_humpyard_element system_element: true
  
      attr_accessible :levels, :show_description
    end
  end
end