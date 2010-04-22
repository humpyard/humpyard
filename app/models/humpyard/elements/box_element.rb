module Humpyard
  module Elements 
    ####
    # Humpyard::Elements::BoxElement is a model of a container element with a box frame.    
    class BoxElement < ::ActiveRecord::Base
      acts_as_humpyard_container_element :system_element => true
      
      attr_accessible :title
      
      require 'globalize'
      
      translates :title
    end
  end
end