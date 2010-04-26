require 'humpyard' unless defined? Humpyard

Humpyard.configure do |config|
  config.www_prefix = ':locale/'
  config.admin_prefix = 'admin'
  config.table_name_prefix = 'humpyard_'
  config.locales = [:en]
 
  # Skeleton generator presets
  config.compass_format = 'scss'
  config.js_framework = 'jquery-ui-18'
  config.users_framework = 'fake'
 
  # Template config
  config.templates = {
    :alternative => {:yields => [:left, :right]},
    :application => {:yields => [:sidebar]}
  }
  config.default_template = :application
      
end