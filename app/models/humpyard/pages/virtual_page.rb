module Humpyard
  module Pages  
    class VirtualPage < ::ActiveRecord::Base
      acts_as_humpyard_page
      
      set_table_name "#{Humpyard::config.table_name_prefix}pages_virtual_pages"  
    
      def is_humpyard_dynamic_page?
        false
      end
  
      def is_humpyard_virtual_page?
        true
      end
  
      def site_map(locale)
        if page.in_sitemap
          {
            url: page.human_url(locale: locale),
            lastmod: page.last_modified,
            hidden: true,
            children: page.child_pages.map{ |p| p.content_data.site_map(locale) }
          }
        else
          nil
        end
      end
    end
  end
end