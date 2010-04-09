module Humpyard
  class NewsFeed < ::ActiveRecord::Base
    set_table_name "#{Humpyard::config.table_name_prefix}news_feeds"

    require 'globalize'

    translates :title, :description

    has_many :news_items, :class_name => 'Humpyard::NewsItem', :foreign_key => :news_feed_id, :order => :created_at


  end
end