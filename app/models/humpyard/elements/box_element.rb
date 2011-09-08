module Humpyard
  module Elements 
    ####
    # Humpyard::Elements::BoxElement is deprecated   
    #
    # Use Humpyard::Elements::ContainerElement instead
    #
    # IMPORTANT: This element will be removed in a future version!
    class BoxElement < ::ActiveRecord::Base
      acts_as_humpyard_container_element system_element: true
      
      attr_accessible :title
      
      require 'globalize'
      
      translates :title
    end
  end
end