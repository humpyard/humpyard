I18n.load_path += Dir.glob("#{File.dirname(__FILE__)}/../config/locales/*.yml")
puts "=> #{I18n.t 'hump_yard.start'}"

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

require 'extensions/action_controller/base'

#model_path = File.join(File.dirname(__FILE__), '..', 'app', 'models')
#$LOAD_PATH << model_path
#ActiveSupport::Dependencies.load_paths << model_path

#controller_path = File.join(File.dirname(__FILE__), '..', 'app', 'controllers')
#$LOAD_PATH << controller_path
#ActiveSupport::Dependencies.load_paths << controller_path
##config.controller_paths << controller_path

##view_path = File.join(File.dirname(__FILE__), 'app', 'views')
##ActionView::view_paths << view_path
##ActionView::Base.view_paths << view_path


