module Humpyard
  VERSION = ::File.read(::File.join(::File.dirname(__FILE__), "..", "VERSION")).strip
  PATH = ::File.join(::File.dirname(__FILE__), '..').to_s

  require File.expand_path('../humpyard/config', __FILE__)
  require File.expand_path('../humpyard/engine', __FILE__)

  def self.load options = {}
    require 'humpyard/rake_tasks'
  end

  class << self
    def config
      @config ||= Humpyard::Config.new
    end

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
