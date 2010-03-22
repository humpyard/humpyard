####
# Welcome to Humpyard
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

require 'i18n'
I18n.load_path += Dir.glob("#{File.dirname(__FILE__)}/../config/locales/*.yml")
puts "=> #{I18n.t 'humpyard.start', :version => Humpyard::VERSION}"

require File.expand_path('../humpyard/action_controller/base', __FILE__)
require File.expand_path('../humpyard/active_record/acts/element', __FILE__)

