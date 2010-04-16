module Humpyard
  module Pages 
    ####
    # Humpyard::Pages::StaticPage is a page only containing elements.    
    class StaticPage < ::ActiveRecord::Base
      acts_as_humpyard_page :system_page => true
      
      def is_humpyard_dynamic_page?
        false
      end
      
      def child_pages
        if self.page.is_root_page?
          self.page.children + self.page.siblings 
        else
          self.page.children
        end
      end
      
      def site_map(locale)
        {
          :url => page.human_url(:locale => locale),
          :lastmod => page.last_modified,
          :children => child_pages.map{ |p| p.content_data.site_map(locale) }
        }
      end
    end
  end
end