require 'compass' 

options = Hash.new
options[:stylesheets_directory] = ::File.expand_path(::File.join(::File.dirname(__FILE__), '..', '..', 'compass', 'stylesheets'))
options[:templates_directory] = ::File.expand_path(::File.join(File.dirname(__FILE__), '..', '..', 'compass', 'templates'))
::Compass::Frameworks.register('humpyard', options)