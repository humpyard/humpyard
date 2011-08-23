module Humpyard
  ####
  # Humpyard::Config is responsible for holding and managing the configuration
  # for your Humpyard Rails Application.
  #
  # Possible configuration options are:
  # +table_name_prefix+:: 
  #    The prefix for the SQL tables
  #
  #    The default value is <tt>"humpyard_"</tt>
  # +www_prefix+::        
  #    The prefix for the pages in your routes
  #
  #    You may use some variables that will be replaced by 
  #    Humpyard::Page.human_url
  #    <tt>":locale"</tt>:: The current ::I18n.locale
  #
  #    Leading slashes ("/") as it would result in invalid URLs and will be ignored.
  #
  #    A tailing slash ("/") indicates, that the value should be a path.
  #    Without the tailing slash the last part would become a prefix
  #    to the pages URL.
  #    A page with the path "about/config.html" with the ::I18n.locale="en" 
  #    and the given prefix will result in:
  #    <tt>":locale/"</tt>:: <tt>"/en/about/config.html"</tt>
  #    <tt>":locale/cms_"</tt>:: <tt>"/en/cms_about_config.html"</tt>
  #    <tt>"cms/"</tt>:: <tt>"/cms/about/config.html"</tt>
  #    <tt>""</tt>: <tt>"/about/config.html"</tt>
  #
  #    The default value is <tt>":locale/"</tt>
  # +admin_prefix+::      
  #    The prefix for the admin controllers
  #
  #    The default value is <tt>"admin"</tt>
  # +locales+::
  #    The locales used for the pages
  #
  #    This option can be configured by giving an Array or comma separated String,
  #    e.g. <tt>'en,de,fr'</tt> or <tt>['en', 'de', 'fr']</tt>.
  #
  #    Setting this option will also alter the HumpyardForm.config.locales to the 
  #    given value
  #
  #
  #    The default value is <tt>['en']</tt>
  class Config 
    attr_writer :table_name_prefix, :element_types, :page_types # :nodoc:
    attr_writer :templates, :default_template, :browser_title_prefix, :browser_title_postfix # :nodoc:
    attr_writer :users_framework, :js_framework, :compass_format, :compass_stylesheet_link_tag_path # :nodoc:
    
    def initialize(&block) #:nodoc:
      configure(&block) if block_given?
    end

    # Configure your Humpyard Rails Application with the given parameters in 
    # the block. For possible options see above.
    def configure(&block)
      yield(self)
    end
    
    def table_name_prefix #:nodoc:
      @table_name_prefix ||= 'humpyard_'
    end
          
    def www_prefix #:nodoc:
      @www_prefix ||= ':locale/'
    end
    
    def www_prefix=(prefix)
      if prefix
        @www_prefix = prefix.gsub /^\//, ''
      else
        @www_prefix = nil
      end
    end
    
    def element_types #:nodoc:
      @element_types ||= {
        'box_element' => Humpyard::Elements::BoxElement,
        'text_element' => Humpyard::Elements::TextElement,
        'media_element' => Humpyard::Elements::MediaElement,
        'news_element' => Humpyard::Elements::NewsElement,
        'sitemap_element' => Humpyard::Elements::SitemapElement
      }
    end
    
    def page_types #:nodoc:
      @page_types ||= {
        'static' => Humpyard::Pages::StaticPage,
        'virtual' => Humpyard::Pages::VirtualPage,
        'news' => Humpyard::Pages::NewsPage
      }
    end
    
    def asset_types #:nodoc:
      @asset_types ||= {
        'paperclip' => Humpyard::Assets::PaperclipAsset,
        'youtube' => Humpyard::Assets::YoutubeAsset
      }
    end
    
    def templates #:nodoc:
      @templates ||= {
        'application' => {yields: [:sidebar]}
      }
    end
    
    def toolbar_actions #:nodoc:
      @toolbar_actions ||= {
        'hy_pages' => {
          title: 'humpyard_cms.toolbar.pages',
          controller: '/humpyard/pages',
          action: :index,
          dialog: "size:800x700;dialog_id:pages-dialog",
          icon: 'ui-icon-document',
          class: Humpyard::Page
        },
        'hy_assets' => {
          title: 'humpyard_cms.toolbar.assets',
          controller: '/humpyard/assets',
          action: :index,
          dialog: "size:800x700;dialog_id:assets-dialog",
          icon: 'ui-icon-video',
          class: Humpyard::Asset
        }
      }
    end
    
    def default_template #:nodoc:
      @default_template ||= templates.keys.first
    end
    
    def default_template_name
      default_template.to_s
    end
 
    def browser_title_prefix #:nodoc:
      @browser_title_prefix ||= ''
    end
    
    def browser_title_postfix #:nodoc:
      @browser_title_postfix ||= ''
    end 
    
    # Get the prefix of your pages with interpreted variables given as params.
    # You normally don't want to call it yourself. Instead use the
    # Humpyard::Page.human_url which will put the current ::I18n.locale into
    # the params.
    def parsed_www_prefix(params)
      prefix = "#{www_prefix}"
      params.each do |key,value|
        prefix.gsub!(":#{key}", value.to_s)
      end
      prefix
    end
    
    def admin_prefix #:nodoc:
      @admin_prefix.blank? ? 'admin' : @admin_prefix
    end
    
    def admin_prefix=(prefix)
      if prefix
        @admin_prefix = prefix.gsub /^\//, ''
      else
        @admin_prefix = nil
      end
    end
    
    def locales=(locales) #:nodoc:
      if locales.nil? 
        @locales = nil
      elsif locales.class == Array
        @locales = locales.map{|l| l.to_sym}
      else
        @locales = locales.split(',').collect{|l| l.to_sym}
      end
      
      # Keep HumpyardForm locales in sync
      HumpyardForm.config.locales = locales
    end
    
    def locales #:nodoc:
      @locales ||= [:en]
    end
    
    # Get the given locales as Regexp constraint. 
    # This may be used to see if a locale matches the configured locales.
    # Usage is e.g. in the routes.
    def locales_contraint
      Regexp.new locales * '|'
    end
    
    def users_framework
      @users_framework ||= 'simple'
    end
    
    def js_framework
      @js_framework ||= 'jquery-ui-18'
    end
    
    def compass_format
      @compass_format ||= 'scss'
    end
    
    def compass_stylesheet_link_tag_path
      @compass_stylesheet_link_tag_path ||= 'compiled/'
    end
    
    def page_formats=(formats) #:nodoc:
      if formats.nil? 
        @page_formats = nil
      elsif formats.class == Array
        @page_formats = formats.map{|l| l.to_sym}
      else
        @page_formats = formats.split(',').collect{|l| l.to_sym}
      end
    end
    
    def page_formats #:nodoc:
      @page_formats ||= [:html]
    end
    
    # Get the given locales as Regexp constraint. 
    # This may be used to see if a locale matches the configured locales.
    # Usage is e.g. in the routes.
    def page_formats_contraint
      Regexp.new page_formats * '|'
    end
  end
end