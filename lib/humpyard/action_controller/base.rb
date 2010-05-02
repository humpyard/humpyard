module Humpyard
  module ActionController #:nodoc:
    module Base #:nodoc:

      def self.included(base)
        base.module_eval do
          helper_attr :humpyard_user
        end
      end

      def humpyard_user    
        current_user
      end
       
    end
  end
end

ActionController::Base.send :include, Humpyard::ActionController::Base

