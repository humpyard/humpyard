module Humpyard
  module Pages 
    ####
    # Humpyard::Pages::NewsPage is a page containing news articles
    class NewsPage < ::ActiveRecord::Base
      acts_as_humpyard_page :system_page => true
      
      require 'globalize'

      translates :description

      has_many :news_items, :class_name => 'Humpyard::NewsItem', :foreign_key => :news_page_id, :order => "#{Humpyard::NewsItem.table_name}.created_at DESC"    
      
      def is_humpyard_dynamic_page?
        true
      end
      
      def parse_path(path)
        return nil if path.size != 4
        begin
          item_created_on = Time.local(path[0], path[1], path[2]).to_date
        rescue
          # Rescue if no valid date was given in first 3 path parts
          return nil
        end
        
        item = news_items.by_title_for_url(path[3]).first
        return nil if item.nil?
        
        return nil if item.created_at.to_date != item_created_on
        
        return {
          :partial => 'detail',
          :locals => {:item => item}
          }
      end
      
      def child_pages
        []
      end
      
      def child_urls
        news_items.map{|i| i.human_url}
      end
    end
  end
end