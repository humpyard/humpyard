module Humpyard
  module Assets
    class PaperclipAsset < ::ActiveRecord::Base
      attr_accessible :media
    
      acts_as_humpyard_asset :system_asset => true
    
      # ToDo render styles - not working for non-images like mp3
    
      begin
        has_attached_file(
          :media, 
          :default_style => :original,
          #:styles => {:preview => ['500x500>', :jpg], :thumb => ['200x100>', :jpg]},
          :path => ":rails_root/public/system/media/:id/:basename.:extension",
          :url => "/system/media/:id/:basename.:extension"
        )
        validates_attachment_presence :media
        after_post_process :update_media_dimensions
      rescue
        puts "Paperclip not usable."
      end
    
      def title
        media_file_name
      end
    
      def url
        media.url
      end
      
      def content_type
        media_content_type
      end
    
      def update_media_dimensions
        begin
          size = Paperclip::Geometry.from_file media.queued_for_write[:original]
          asset.width = size.width.to_i
          asset.height = size.height.to_i
        rescue
          asset.width = nil
          asset.height = nil
        end
      end
    end
  end
end
