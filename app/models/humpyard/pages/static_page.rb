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
        if self.name == 'index'
          self.page.children + self.page.siblings 
        else
          self.page.children
        end
      end
      
      def child_urls
        child_pages.map{|p| p.human_url}
      end
    end
  end
end