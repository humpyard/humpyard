module Humpyard
  module Assets
    class YoutubeAsset < ::ActiveRecord::Base
      attr_accessible :youtube_video_id
    
      acts_as_humpyard_asset system_asset: true
    
      validates_presence_of :youtube_video_id
      before_save :update_youtube_data
      
      def url(version = 'original')
        "http://www.youtube.com/watch?v=#{youtube_video_id}"
      end
      
      def asset_name
        youtube_title || "YouTube #{youtube_video_id}"
      end
      
      def content_type
        'video/youtube'
      end
      
      def update_youtube_data      
        begin
          require 'net/http'

          xml = Net::HTTP.get_response(URI.parse("http://gdata.youtube.com/feeds/api/videos/#{youtube_video_id}")).body
          self.youtube_title = xml.force_encoding("UTF-8").scan(/<title.*>(.+?)<\/title>/).first.first
        rescue
          # Set to some sane default values if YouTube is not available
          self.youtube_title = "YouTube #{youtube_video_id}"
        end
        
        # As YouTube does not offer Video dimensions, always set to 480x360 (default thumbnail size)
        self.asset.update_attributes width: 480, height: 360, title: youtube_title
        
        
      end
    end
  end
end