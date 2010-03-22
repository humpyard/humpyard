require 'rails/generators/base'
 
module Humpyard
  module Generators
    class Base < Rails::Generators::Base #:nodoc:
      def self.source_root
        @_humpyard_source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'humpyard', generator_name, 'templates'))
      end
 
      def self.banner
        "#{$0} humpyard:#{generator_name} #{self.arguments.map{ |a| a.usage }.join(' ')} [options]"
      end
    end
  end
end