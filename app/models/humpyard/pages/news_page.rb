module Humpyard
  module Pages 
    ####
    # Humpyard::Pages::NewsPage is a page containing news articles
    class NewsPage < ::ActiveRecord::Base
      acts_as_humpyard_page :system_page => true

      has_many :news_items, :class_name => 'Humpyard::NewsItem', :foreign_key => :news_page_id, :order => "#{Humpyard::NewsItem.table_name}.created_at DESC"    
      has_many :news_elements, :class_name => 'Humpyard::Elements::NewsElement', :foreign_key => :news_page_id
      
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
        
        item = news_items.find_by_title_for_url(path[3])
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
      
      def parent_page
        super
      end
      
      def site_map(locale)
        if page.in_sitemap        
          {
            :url => page.human_url(:locale => locale),
            :lastmod => page.last_modified,
            :hidden => !page.in_sitemap,
            :children => news_items.map do |i|
              { 
                :url => i.human_url(:locale => locale),
                :lastmod => i.updated_at,
                :hidden => !page.in_sitemap,
                :children => []
              }
            end
          }  
        else
          nil
        end
      end
      
      # Return the logical modification time for the page, suitable for http caching, generational cache keys, etc.
      def last_modified_with_news_items
        timestamps = [last_modified_without_news_items] + news_items.collect{|i| i.updated_at}
        timestamps.sort.last
      end
      alias_method_chain :last_modified, :news_items
    end
  end
end