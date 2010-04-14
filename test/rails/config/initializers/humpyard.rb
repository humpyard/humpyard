require 'humpyard' unless defined? Humpyard

Humpyard.configure do |config|
  config.www_prefix = ':locale/'
  config.admin_prefix = 'admin'
  config.table_name_prefix = 'humpyard_'
  config.locales = [:en]
  
  config.templates = {
    :application => {:yields => [:sidebar]},
    :alternative => {:yields => [:left, :right]}
  }
  config.default_template = :application
  
end