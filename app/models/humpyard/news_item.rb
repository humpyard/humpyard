module Humpyard
  class NewsItem < ::ActiveRecord::Base
    set_table_name "#{Humpyard::config.table_name_prefix}news_items"

    before_validation :assign_title_for_url

    require 'globalize'

    translates :title, :title_for_url, :content

    belongs_to :news_page, :class_name => "Humpyard::Pages::NewsPage", :foreign_key => "news_page_id"

    validates_presence_of :title, :title_for_url
    # does not to work in globalize until now
    # validates_uniqueness_of :title_for_url
    
    scope :by_title_for_url, lambda { |locale,name| {
      :include => :translations,
      :conditions => ["#{quoted_translation_table_name}.locale = ? AND #{quoted_translation_table_name}.title_for_url = ?", locale.to_s, name.to_s]
    }}

    # Return the human readable URL for the page.
    #
    # Posible options values are
    # <tt>:locale</tt>:: 
    #     A locale given in the Humpyard::Config.locales.
    #     If no <tt>:locale</tt> is given the option will be ::I18n.locale by default
    def human_url(options={})
      options[:locale] ||= ::I18n.locale
      
      unless Humpyard::config.locales.include? options[:locale].to_sym
        options[:locale] = Humpyard::config.locales.first
      end
      
      news_page.page.human_url(options).gsub /\.html$/, "/#{created_at.strftime '%Y/%m/%d'}/#{t = p.translations.select{|t| t.locale == options[:locale]}.first ? t.title_for_url : title_for_url}.html"
    end
    
    private
    def assign_title_for_url
      self.title_for_url = title.parameterize('_').to_s
      
      # Check if parameterized totally failed
      if self.title_for_url == ''
        self.title_for_url = CGI::escape(title.gsub(/[a-z0-9\-_\x00-\x7F]+/, '_'))
      end 

      while p = Humpyard::NewsItem.by_title_for_url(I18n.locale, self.title_for_url).first and p.id != id do
        self.title_for_url += '_'
      end
    end

  end
end