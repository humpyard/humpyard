module Humpyard
  module Elements 
    ####
    # Humpyard::Elements::ContainerElement is a model of a container element.    
    class ContainerElement < ::ActiveRecord::Base
      acts_as_humpyard_container_element system_element: true
      
      attr_accessible :title, :preset
      validates :preset, presence: true
      
      require 'globalize'
      
      translates :title
    end
  end
end