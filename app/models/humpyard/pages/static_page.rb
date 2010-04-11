module Humpyard
  module Pages 
    ####
    # Humpyard::Pages::StaticPage is a model of a text element.    
    class StaticPage < ::ActiveRecord::Base
      acts_as_humpyard_page :system_page => true
      
      def is_humpyard_dynamic_page?
        false
      end
      
      def child_pages
        if self.name == 'index'
          self.page.siblings
        else
          self.page.children
        end
      end
    end
  end
end