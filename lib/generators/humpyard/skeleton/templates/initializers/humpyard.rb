require 'humpyard' unless defined? Humpyard

Humpyard.configure do |config|
  config.www_prefix = '<%= options[:www_prefix] %>'
  config.admin_prefix = '<%= options[:admin_prefix] %>'
  config.table_name_prefix = '<%= options[:table_name_prefix] %>'
  config.locales = [:<%= options[:locales] * ', :' %>]
end