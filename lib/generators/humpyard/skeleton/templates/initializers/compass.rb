require 'compass'
# If you have any compass plugins, require them here.
Compass.add_project_configuration(File.join(Rails.root, "config", "compass.config"))
Compass.configuration.environment = Rails.env.to_sym
Compass.configure_sass_plugin!

if Rails.env == 'production'
  sh "rm -rf #{Rails.root}/public/stylesheets/compiled #{Rails.root}/tmp/sass-cache"
  Sass::Plugin.options[:never_update] = false
  Sass::Plugin.update_stylesheets
  Sass::Plugin.options[:never_update] = true
end