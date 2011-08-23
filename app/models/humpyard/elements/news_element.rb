module Humpyard
  module Elements 
    ####
    # Humpyard::Elements::TextElement is a model of a text element.    
    class NewsElement < ::ActiveRecord::Base
      acts_as_humpyard_element system_element: true
      
      attr_accessible :news_page, :news_page_id
  
      belongs_to :news_page, class_name: 'Humpyard::Pages::NewsPage'
    end
  end
end