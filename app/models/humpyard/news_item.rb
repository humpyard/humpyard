module Humpyard
  class NewsItem < ::ActiveRecord::Base
    set_table_name "#{Humpyard::config.table_name_prefix}news_items"

    require 'globalize'

    translates :title, :content

    belongs_to :news_feed, :class_name => "Humpyard::NewsFeed", :foreign_key => "news_feed_id"

  end
end