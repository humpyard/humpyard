####
# Welcome to Humpyard
module Humpyard
  # This is the actual version of the Humpyard gem
  VERSION = ::File.read(::File.join(::File.dirname(__FILE__), "..", "VERSION")).strip
  # This is the path to the Humpyard gem's root directory
  PATH = ::File.join(::File.dirname(__FILE__), '..').to_s

  require File.expand_path('../humpyard/config', __FILE__)
  require File.expand_path('../humpyard/engine', __FILE__)

  def self.load options = {} #:nodoc:
    require 'humpyard/rake_tasks'
  end

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

require 'i18n'
::I18n.load_path += Dir.glob("#{File.dirname(__FILE__)}/../config/locales/*.yml")
puts "=> #{I18n.t 'humpyard.start', :version => Humpyard::VERSION}"

require 'haml'
::Haml.init_rails(binding) if defined?(Haml)

require File.expand_path('../extensions/action_controller/base', __FILE__)

require File.expand_path('../humpyard/active_record/acts/element', __FILE__)
ActiveRecord::Base.send :include, Humpyard::ActiveRecord::Acts::Element
