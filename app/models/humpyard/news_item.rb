module Humpyard
  class NewsItem < ::ActiveRecord::Base
    set_table_name "#{Humpyard::config.table_name_prefix}news_items"

    belongs_to :news_page, class_name: "Humpyard::Pages::NewsPage", foreign_key: "news_page_id"

    require 'globalize'

    translates :title, :title_for_url, :content
    has_title_for_url
        
    validates_presence_of :title
    
    
    # Return the human readable URL for the page.
    #
    # Posible options values are
    # <tt>:locale</tt>:: 
    #     A locale given in the Humpyard::Config.locales.
    #     If no <tt>:locale</tt> is given the option will be ::I18n.locale by default
    def human_url(options={})
      options[:locale] ||= ::I18n.locale
      options[:format] ||= :html
      
      unless Humpyard::config.locales.include? options[:locale].to_sym
        options[:locale] = Humpyard::config.locales.first
      end
      
      if options[:path_format]
        format = "/"
      else
        format = ".#{options[:format].to_s}" 
      end
      
      page_options = options
      page_options[:path_format] = true
      
      "#{news_page.page.human_url(page_options)}#{created_at.strftime '%Y/%m/%d'}/#{query_title_for_url(options[:locale])}#{format}"
    end
    
  end
end