module Humpyard
  module Pages  
    class RedirectPage < ::ActiveRecord::Base
      acts_as_humpyard_page :system_page => true
      
      attr_accessible :redirect_uri, :status_code
      
      set_table_name "#{Humpyard::config.table_name_prefix}pages_redirect_pages"  
    
      def is_humpyard_dynamic_page?
        false
      end
  
      def is_humpyard_virtual_page?
        false
      end
      
      def redirect_on_render
        [redirect_uri, status_code]
      end
  
      def site_map(locale)
        if page.in_sitemap
          {
            url: page.human_url(locale: locale),
            lastmod: page.last_modified,
            children: page.child_pages.map{ |p| p.content_data.site_map(locale) }
          }
        else
          nil
        end
      end
    end
  end
end