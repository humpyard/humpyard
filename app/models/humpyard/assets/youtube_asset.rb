module Humpyard
  module Assets
    class YoutubeAsset < ::ActiveRecord::Base
      attr_accessible :youtube_video_id
    
      acts_as_humpyard_asset :system_asset => true
    
      validates_presence_of :youtube_video_id
      before_save :update_youtube_data
      
      def url
        "http://www.youtube.com/watch?v=#{youtube_video_id}"
      end
      
      def title
        youtube_title || "YouTube #{youtube_video_id}"
      end
      
      def content_type
        'video/youtube'
      end
      
      def update_youtube_data
        begin
          require 'net/http'

          xml = Net::HTTP.get_response(URI.parse("http://gdata.youtube.com/feeds/api/videos/#{youtube_video_id}")).body

          title = xml.force_encoding("UTF-8").scan(/<title.*>(.+?)<\/title>/).first.first
        
          self.youtube_title = title
        rescue
          self.youtube_title = "YouTube #{youtube_video_id}"
        end
      end
    end
  end
end