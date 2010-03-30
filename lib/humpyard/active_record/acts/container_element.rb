module Humpyard
  module ActiveRecord
    module Acts
      module ContainerElement
        def self.included(base)
          base.acts_as_humpyard_element

          base.delegate "elements", "elements=", "elements?", :to => :element
          
          base.extend ClassMethods
        end
        
        module ClassMethods
          def is_humpyard_container_element?
            true
          end          
        end
      end
    end
  end
end

class ActiveRecord::Base
  def self.acts_as_humpyard_container_element(options = {})
    include Humpyard::ActiveRecord::Acts::ContainerElement
  end
end