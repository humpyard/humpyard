####
# Welcome to Humpyard
require 'cancan'
require 'humpyard_form'

module Humpyard
  # This is the actual version of the Humpyard gem
  VERSION = ::File.read(::File.join(::File.dirname(__FILE__), "..", "VERSION")).strip  
    
  def self.load options = {} #:nodoc:
    require ::File.expand_path('../humpyard/rake_tasks', __FILE__)
  end
  
  # This is the path to the Humpyard gem's root directory
  def base_directory
    ::File.expand_path(::File.join(::File.dirname(__FILE__), '..'))
  end
  
  # This is the path to the Humpyard gem's lib directory
  def lib_directory
    ::File.expand_path(::File.join(::File.dirname(__FILE__)))
  end
    
  module_function :base_directory, :lib_directory

  class << self    
    # To access the actual configuration of your Humpyard, you can call this.
    #
    # An example would be <tt>Humpyard.config.www_prefix = 'cms/:locale/'</tt>
    #
    # See Humpyard::Config for configuration options.
    def config
      @config ||= Humpyard::Config.new
    end
    
    def uri_parser
      @uri_parser ||= Humpyard::UriParser
    end

    # Configure the Humpyard 
    # See Humpyard::Config.configure for details
    def configure(&block)
      config.configure(&block)
    end
  end
end

require File.expand_path('../humpyard/config', __FILE__)
require File.expand_path('../humpyard/engine', __FILE__)
require File.expand_path('../humpyard/compass', __FILE__)
require File.expand_path('../humpyard/uri_parser', __FILE__)
require File.expand_path('../humpyard/uri_parser/pages_uri_parser', __FILE__)

require 'i18n'
I18n.load_path += Dir.glob("#{File.dirname(__FILE__)}/../config/locales/*.yml")
I18n.backend.reload!
puts "=> #{I18n.t :'humpyard_cms.start', :version => Humpyard::VERSION, :raise => true}"

require File.expand_path('../humpyard/action_controller/base', __FILE__)
require File.expand_path('../humpyard/active_model/validators/publish_range', __FILE__)
require File.expand_path('../humpyard/active_model/translation', __FILE__)
require File.expand_path('../humpyard/active_model/naming', __FILE__)
require File.expand_path('../humpyard/active_record/acts/element', __FILE__)
require File.expand_path('../humpyard/active_record/acts/container_element', __FILE__)
require File.expand_path('../humpyard/active_record/acts/page', __FILE__)
require File.expand_path('../humpyard/active_record/has/title_for_url', __FILE__)


