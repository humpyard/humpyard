module Humpyard
  module ActionController #:nodoc:
    module Base #:nodoc:

      def self.included(base)
        base.module_eval do
          helper_attr :humpyard_user
          helper_attr :humpyard_logout_path
        end
      end

      def humpyard_user    
        current_user
      end
       
      def humpyard_logout_path
        "?user="
      end
    end
  end
end

ActionController::Base.send :include, Humpyard::ActionController::Base

