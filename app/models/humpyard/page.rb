module Humpyard
  ####
  # Humpyard::Page is the model for your pages. It holds the 
  # Humpyard::Elements containing the content of your page
  # and some meta data for the page itself.
  class Page < ::ActiveRecord::Base
    set_table_name "#{Humpyard::config.table_name_prefix}pages"
    require 'acts_as_tree'
    require 'globalize'
    
    translates :title, :description
    
    acts_as_tree :order => :position
    
    belongs_to :content_data, :polymorphic => true, :dependent => :destroy  
    has_many :elements, :class_name => 'Humpyard::Element', :dependent => :destroy  
    
    validates_with Humpyard::PublishRangeValidator, {:attributes => [:display_from, :display_until]}
    validates_presence_of :title, :name
    validates_uniqueness_of :name
        
    def self.root_page
      Humpyard::Page.where('name = ?', 'index').first
    end    
        
    def root_elements(yield_name = 'main')
      elements.where('container_id IS NULL and page_yield_name = ?', yield_name.to_s).order('position ASC')
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
      
      if self.name == 'index'
        "/#{Humpyard::config.parsed_www_prefix(options).gsub(/[^\/]*$/, '')}"
      else
        "/#{Humpyard::config.parsed_www_prefix(options)}#{(self.ancestors.reverse + [self]).collect{|p| p.name} * '/'}.html"
      end
    end
    
    def suggested_name
      if self.name == 'index' or Humpyard::Page.count == 0
        return 'index'
      else
        #name = Iconv.iconv('ascii//translit//IGNORE', 'utf-8', self.title).to_s
        #name.gsub!(/[^\x00-\x7F]+/, '') # Remove anything non-ASCII entirely (e.g. diacritics).
        #name.gsub!(/[^\w_ \_]+/i,   '') # Remove unwanted chars.
        #name.gsub!(/[ \_]+/i,      '_') # No more than one of the separator in a row.
        #name.gsub!(/^\_|\_$/i,      '') # Remove leading/trailing separator.
        #name.downcase!
        
        # Use Rails function instead of the above
        # Both does not work for non latin character sets
        name = self.title.parameterize('_').to_s
        
        # Check if parameterized totally failed
        if name == ''
          name = CGI::escape(self.title.gsub(/[a-z0-9\-_\x00-\x7F]+/, '_'))
        end 

        while p = Humpyard::Page.where('name = ?', name).first and p.id != self.id do
          name += '_'
        end
        return name
      end  
    end
    
    # Find the child pages
    def child_pages
      content_data.child_pages
    end
    
    # Return the logical modification time for the page, suitable for http caching, generational cache keys, etc.
    def last_modified
      rails_root_mtime = Time.zone.at(::File.new("#{Rails.root}").mtime)
      timestamps = [rails_root_mtime, self.updated_at] + self.elements.collect{|element| element.last_modified}
      timestamps.sort.last
    end
  end
end