module Humpyard
  module Elements 
    ####
    # Humpyard::Elements::TextElement is a model of a text element.    
    class TextElement < ::ActiveRecord::Base
      acts_as_humpyard_element
      
      require 'globalize'
      
      translates :content
    end
  end
end