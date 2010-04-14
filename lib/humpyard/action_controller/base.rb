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


# register a custom json renderer for humpyard to overcome xhr file upload limits.
# if a file input is present in the form, it should be sent as a normal form
# submit, targeted to a (hidden) iframe. client code can pick up the response from there.
# two things with this workaround: the MIME type cannot be the proper json type
# because the response would end up being downloaded by common browsers.
# additionally, there is some escaping going on in the browser which can
# render the json unparseable. to prevent this, we send the json wrapped
# in a <textarea> element. (this is the way jquery.form handles things)
# until there is a decent way to upload files using xhr (also supporting 
# streaming large uploads), we have to use this rather ugly hack.
# this code is based on the original rails :json option for rendering.
# to use the workaround, include a parameter url_quirk=true in the request.

ActionController.add_renderer :json do |json, options|
 json = ActiveSupport::JSON.encode(json) unless json.respond_to?(:to_str)
 json = "#{options[:callback]}(#{json})" unless options[:callback].blank?
 if params[:ul_quirk]
   self.content_type ||= Mime::HTML
   self.response_body = "<textarea>" + json + "</textarea>"
 else
   self.content_type ||= Mime::JSON
   self.response_body = json
 end
end