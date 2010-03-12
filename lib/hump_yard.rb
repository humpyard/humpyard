module HumpYard
  VERSION = '0.0.0'
  PATH = File.join(File.dirname(__FILE__), '..').to_s

  autoload :Config, "rack/config"
  require 'hump_yard/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3

  def self.load options = {}
    require 'hump_yard/rake_tasks'
    #Kernel.load recipes[:config]
  end

  class << self
    def config
      @config ||= HumpYard::Config.new
    end

    def configure(&block)
      config.configure(&block)
    end
  end
end

require 'i18n'
I18n.load_path += Dir.glob("#{File.dirname(__FILE__)}/../config/locales/*.yml")
puts "=> #{I18n.t 'hump_yard.start'}"

require 'haml'
Haml.init_rails(binding) if defined?(Haml)

require 'extensions/action_controller/base'
