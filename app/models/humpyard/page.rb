module Humpyard
  ####
  # Humpyard::Page is the model for your pages. It holds the 
  # Humpyard::Elements containing the content of your page
  # and some meta data for the page itself.
  class Page < ::ActiveRecord::Base
    set_table_name "#{Humpyard::config.table_name_prefix}pages"
    require 'acts_as_tree'
    require 'globalize'
    
    translates :title, :title_for_url, :description
    has_title_for_url
    
    acts_as_tree :order => :position
    
    belongs_to :content_data, :polymorphic => true, :dependent => :destroy  
    has_many :elements, :class_name => 'Humpyard::Element', :dependent => :destroy  
    
    validates_with Humpyard::PublishRangeValidator, {:attributes => [:display_from, :display_until]}
    validates_presence_of :title
    
    def self.root_page
      Humpyard::Page.find_by_title_for_url :index
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
    
    def template_name
      self[:template_name] || Humpyard::config.default_template_name
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
    
    
    def suggested_title_for_url_with_index
      return 'index' if self.is_root_page? or Humpyard::Page.count == 0   
      suggested_title_for_url_without_index
    end
    alias_method_chain :suggested_title_for_url, :index
    
    # Find the child pages
    def child_pages
      content_data.child_pages
    end
    
    # Return the logical modification time for the page, suitable for http caching, generational cache keys, etc.
    def last_modified
      content_data.nil? ? nil : content_data.last_modified
    end
    
  end
end