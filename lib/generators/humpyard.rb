require 'rails/generators/base'
 
module Humpyard
  ####
  # = Humpyard::Generators
  #
  module Generators
    class Base < Rails::Generators::Base #:nodoc:
      def self.source_root
        @_humpyard_source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'humpyard', generator_name, 'templates'))
      end
 
      def self.banner
        "#{$0} humpyard:#{generator_name} #{self.arguments.map{ |a| a.usage }.join(' ')} [options]"
      end
    end
    
    module ModelTemplate
      
      def self.included(base) #:nodoc:
        base.extend ClassMethods
        
        base.argument :model_attributes, :type => :array, :default => [], :banner => 'field:type field:type'

        base.class_option :skip_model, :desc => 'Don\'t generate a model or migration file.', :type => :boolean
        base.class_option :skip_migration, :desc => 'Dont generate migration file for model.', :type => :boolean
        base.class_option :skip_timestamps, :desc => 'Don\'t add timestamps to migration file.', :type => :boolean
        base.class_option :skip_views, :desc => 'Don\'t generate view files.', :type => :boolean

        base.class_option :skip_tests, :desc => 'Don\'t generate test files.', :group => 'Test framework', :type => :boolean
        base.class_option :test_unit, :desc => 'Use test/unit for test files.', :group => 'Test framework', :type => :boolean
        base.class_option :rspec, :desc => 'Use RSpec for test files.', :group => 'Test framework', :type => :boolean
        base.class_option :shoulda, :desc => 'Use shoulda for test files.', :group => 'Test framework', :type => :boolean
      end
      
      private

      def create_model options # :nodoc:        

      end
      
      def attributes
        if @attributes 
          return @attributes
        else
          @attributes = []
          model_attributes.each do |attr|
            splitted = attr.split(':')
            @attributes << Rails::Generators::GeneratedAttribute.new(splitted[0], splitted[1])
          end
          @attributes
        end
      end

      def model_name
        raise "You have to specify model name in your Generator"
      end

      def singular_name
        model_name.underscore
      end

      def plural_name
        model_name.underscore.pluralize
      end

      def class_name
        model_name.camelize
      end

      def plural_class_name
        plural_name.camelize
      end

      def model_exists?
        File.exist? destination_path("app/models/#{singular_name}.rb")
      end
      
      def test_framework
        return @test_framework if defined?(@test_framework)
        
        if options.rspec?
          return @test_framework = :rspec
        elsif options.test_unit?
          return @test_framework = :test_unit
        elsif options.shoulda?
          return @test_framework = :shoulda
        else
          return @test_framework = default_test_framework
        end
      end

      def default_test_framework
        Rails.application::config.generators.rails[:test_framework]
      end

      def destination_path(path)
        File.join(destination_root, path)
      end

      module ClassMethods
        # Implement the required interface for Rails::Generators::Migration.
        #
        def next_migration_number(dirname) #:nodoc:
          if ::ActiveRecord::Base.timestamped_migrations
            Time.now.utc.strftime("%Y%m%d%H%M%S")
          else
            "%.3d" % (current_migration_number(dirname) + 1)
          end
        end
      end
    end
  end
end