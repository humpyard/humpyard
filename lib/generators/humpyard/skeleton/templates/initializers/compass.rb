require 'compass'
# If you have any compass plugins, require them here.
Compass.add_project_configuration(File.join(Rails.root, "config", "compass.config"))
Compass.configuration.environment = Rails.env.to_sym
Compass.configure_sass_plugin!

if ['production', 'staging'].include? Rails.env 
  Sass::Plugin.options[:style] = :compressed
  
  FileUtils.rm_rf "#{Rails.root}/public/stylesheets/*.css"
  FileUtils.rm_rf "#{Rails.root}/tmp/sass-cache"

  Sass::Plugin.options[:never_update] = false
  Sass::Plugin.update_stylesheets
  Sass::Plugin.options[:never_update] = true
end