module Humpyard
  module ActionController #:nodoc:
    module Base #:nodoc:

      def humpyard_user
        if not @humpyard_user.nil?
          @humpyard_user 
        else
          session[:humpyard] ||= {}
          unless params[:user].nil?
            session[:humpyard][:user] = params[:user]
          end
          @humpyard_user = session[:humpyard][:user] || false
        end
      end 
      
    end
  end
end

ActionController::Base.send :include, Humpyard::ActionController::Base
ActionController::Base.send :helper_attr, :humpyard_user