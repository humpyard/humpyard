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
  #    A tailing "/" indicates, that the value should be a path.
  #    Without the tailing "/" the last part would become a prefix
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
  #
  #    The default value is <tt>['en']</tt>
  class Config 
    attr_writer :table_name_prefix, :www_prefix, :admin_prefix # :nodoc:
    
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
    
    def locales=(locales) #:nodoc:
      if locales.nil? 
        @locales = nil
      elsif locales.class == Array
        @locales = locales.map{|l| l.to_sym}
      else
        @locales = locales.split(',').collect{|l| l.to_sym}
      end
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
  end
end