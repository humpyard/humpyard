module Humpyard
  ####
  # Humpyard::Page is the model for your pages. It holds the 
  # Humpyard::Elements containing the content of your page
  # and some meta data for the page itself.
  class Page < ::ActiveRecord::Base
    set_table_name "#{Humpyard::config.table_name_prefix}pages"
    require 'acts_as_tree'
    require 'globalize'
    
    attr_accessible :title, :title_for_url, :description
    attr_accessible :template_name, :content_data, :content_data_id, :content_data_type
    attr_accessible :parent, :parent_id, :in_menu, :in_sitemap, :searchable
    attr_accessible :display_from, :display_until
    attr_accessible :modified_at, :refresh_scheduled_at
    attr_accessible :updated_at
    
    translates :title, :title_for_url, :description
    has_title_for_url
    
    acts_as_tree :order => :position
    
    belongs_to :content_data, :polymorphic => true, :dependent => :destroy  
    has_many :elements, :class_name => 'Humpyard::Element', :dependent => :destroy  
    
    validates_with Humpyard::ActiveModel::PublishRangeValidator, {:attributes => [:display_from, :display_until]}
    validates_presence_of :title
    
    def self.root_page
      @root_page ||= Humpyard::Page.select(:id).with_translated_attribute(:title_for_url, :index).first
    end    
    
    def is_root_page?
      self.id and Humpyard::Page.root_page and self.id == Humpyard::Page.root_page.id
    end
        
    # Return the elements on a yield container. Includes shared elemenents from siblings or parents
    #
    def root_elements(yield_name = 'main')
      # my own elements
      ret = elements.where('container_id IS NULL and page_yield_name = ?', yield_name.to_s).order('position ASC')
      # sibling shared elements
      unless siblings.empty?
        ret += Humpyard::Element.where('container_id IS NULL and page_id in (?) and page_yield_name = ? and shared_state = ?', siblings, yield_name.to_s, Humpyard::Element::SHARED_STATES[:shared_on_siblings]).order('position ASC')
      end
      # ancestors shared elements
      unless ancestor_pages.empty?
        ret += Humpyard::Element.where('container_id IS NULL and page_id in (?) and page_yield_name = ? and shared_state = ?', ancestor_pages, yield_name.to_s, Humpyard::Element::SHARED_STATES[:shared_on_children]).order('position ASC')
      end
      ret
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
      options[:format] ||= :html
      
      unless Humpyard::config.locales.include? options[:locale].to_sym
        options[:locale] = Humpyard::config.locales.first
      end
      
      if options[:path_format]
        format = "/"
      else
        format = ".#{options[:format].to_s}" 
      end
      
      if self.title_for_url == 'index' or self.is_root_page?
        "/#{Humpyard::config.parsed_www_prefix(options).gsub(/[^\/]*$/, '')}"
      else
        "/#{Humpyard::config.parsed_www_prefix(options)}#{((self.ancestors.reverse + [self]).collect{|p| p.query_title_for_url(options[:locale])} - ['index']) * '/'}#{format}".gsub(/^index\//,'')
      end
    end
    
    
    def suggested_title_for_url_with_index(locale = I18n.locale)
      return 'index' if self.is_root_page? or Humpyard::Page.count == 0   
      suggested_title_for_url_without_index(locale)
    end
    alias_method_chain :suggested_title_for_url, :index
    
    # Find the child pages
    def child_pages
      if content_data.is_humpyard_dynamic_page?
        content_data.child_pages
      else
        if is_root_page?
          children + siblings 
        else
          children
        end
      end
    end
    
    # Get the parent page (even on dynamic pages)
    def parent_page
      if parent
        parent
      elsif is_root_page?
        nil
      else
        Humpyard::Page.root_page
      end
    end
    
    # Get all ancestor pages
    def ancestor_pages
      if parent_page
        parent_page.ancestor_pages + [parent_page]
      else
        []
      end
    end
    
    # Is the given page an ancestor of the actual page
    def is_ancestor_page_of? page
      page.ancestor_pages.include? self
    end
    
    # Return the logical modification time for the page, suitable for http caching, generational cache keys, etc.
    def last_modified options = {}
      changed_at = [Time.zone.at(::File.new("#{Rails.root}").mtime), created_at, updated_at, modified_at]
      
      if(options[:include_pages])
        changed_at << Humpyard::Page.select('updated_at').order('updated_at DESC').first.updated_at
      end
      
      (changed_at - [nil]).max.utc    
    end
  end
end