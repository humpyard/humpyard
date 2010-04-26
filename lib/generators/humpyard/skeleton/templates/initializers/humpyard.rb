require 'humpyard' unless defined? Humpyard

Humpyard.configure do |config|
  config.www_prefix = '<%= options[:www_prefix] %>'
  config.admin_prefix = '<%= options[:admin_prefix] %>'
  config.table_name_prefix = '<%= options[:table_name_prefix] %>'
  config.locales = [:<%= options[:locales] * ', :' %>]
 
  # Skeleton generator presets
  config.compass_format = '<%= options[:compass_format] %>'
  config.js_framework = '<%= options[:js_framework] %>'
  config.users_framework = '<%= options[:users_framework] %>'
 
  # Template config
  config.templates = {
    <%= options[:templates].map{|template| ":#{template} => {:yields => [:#{(Humpyard::config.templates[template] ? Humpyard::config.templates[template][:yields] : ['sidebar']) * ', :'}]}"} * ",\n    " %>
  }
  config.default_template = :<%= options[:default_template] %>
      
end