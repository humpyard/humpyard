module Humpyard
  module Elements 
    ####
    # Humpyard::Elements::ContainerElement is a model of a container element.    
    class ContainerElement < ::ActiveRecord::Base
      acts_as_humpyard_element
      
      has_many :elements, :class_name => 'Humpyard::Element', :foreign_key => :container_id
    end
  end
end