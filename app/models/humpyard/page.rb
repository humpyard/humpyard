module Humpyard
  ####
  # Humpyard::Page is the model for your pages. It holds the 
  # Humpyard::Elements containing the content of your page
  # and some meta data for the page itself.
  class Page < ::ActiveRecord::Base
    set_table_name "#{Humpyard::config.table_name_prefix}pages"
    require 'acts_as_tree'
    require 'globalize'
    
    before_save :assign_title_for_url 
    
    translates :title, :title_for_url, :description
    
    acts_as_tree :order => :position
    
    belongs_to :content_data, :polymorphic => true, :dependent => :destroy  
    has_many :elements, :class_name => 'Humpyard::Element', :dependent => :destroy  
    
    validates_with Humpyard::PublishRangeValidator, {:attributes => [:display_from, :display_until]}
    validates_presence_of :title#, :title_for_url
    #validates_uniqueness_of :title_for_url
    
    scope :by_title_for_url, lambda { |locale,name| {
      :include => :translations,
      :conditions => ["#{quoted_translation_table_name}.locale = ? AND #{quoted_translation_table_name}.title_for_url = ?", locale.to_s, name.to_s]
    }}
    
    def self.root_page
      Humpyard::Page.includes(:translations).where("#{quoted_translation_table_name}.title_for_url = ?", 'index').first
    end    
    
    def is_root_page?
      self.id and Humpyard::Page.root_page and self.id == Humpyard::Page.root_page.id
    end
        
      
    def root_elements(yield_name = 'main')
      elements.where('container_id IS NULL and page_yield_name = ?', yield_name.to_s).order('position ASC')
    end 
    
    def parse_path(path)
      content_data.parse_path(path)
    end
    
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
      
      if self.title_for_url == 'index' or self.is_root_page?
        "/#{Humpyard::config.parsed_www_prefix(options).gsub(/[^\/]*$/, '')}"
      else
        "/#{Humpyard::config.parsed_www_prefix(options)}#{((self.ancestors.reverse + [self]).collect{|p| p.query_title_for_url(options[:locale])} - ['index']) * '/'}.html".gsub(/^index\//,'')
      end
    end
    
    def query_title_for_url(locale=I18n.locale)
      given = translations.all
      ([locale.to_sym] + (Humpyard::config.locales.map{|l| l.to_sym} - [locale.to_sym])).each do |l|
        t=given.select{|tx| tx.locale.to_sym == l}.first
        return t.title_for_url if t and not t.title_for_url.blank?
      end    
      nil 
    end
    
    def suggested_title_for_url
      if self.is_root_page? or Humpyard::Page.count == 0
        return 'index'
      else
        return nil if title.blank?
        
        title_for_url = self.title.parameterize('_').to_s
        
        # Check if parameterized totally failed
        if title_for_url == ''
          title_for_url = CGI::escape(self.title.gsub(/[a-z0-9\-_\x00-\x7F]+/, '_'))
        end 

        while p = Humpyard::Page.by_title_for_url(I18n.locale, title_for_url).first and p.id != self.id do
          title_for_url += '_'
        end
      end  
      return title_for_url
    end
    
    # Find the child pages
    def child_pages
      content_data.child_pages
    end
    
    # Return the logical modification time for the page, suitable for http caching, generational cache keys, etc.
    def last_modified
      content_data.last_modified
    end
    
    private
    def assign_title_for_url
      self.title_for_url = suggested_title_for_url
    end  
  end
end