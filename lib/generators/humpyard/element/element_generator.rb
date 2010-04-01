require 'generators/humpyard'
require 'rails/generators/named_base'
require 'rails/generators/migration'
require 'rails/generators/active_model'
require 'active_record'

module Humpyard
  module Generators
    ####
    # == Element Generator
    #
    #   rails humpyard:element ElementName [field:type field:type] [options]
    #
    # === Description
    # The humpyard element generator creates a custom element that can 
    # be used inside your humpyard pages.
    #
    # === Options
    # <tt>[--skip-model]</tt>:: Don't generate a model or migration file.
    # <tt>[--skip-migration]</tt>:: Dont generate migration file for model.
    # <tt>[--skip-timestamps]</tt>:: Don't add timestamps to migration file.
    # <tt>[--skip-views]</tt>:: Don't generate view files.
    #
    # === Runtime options
    # <tt>-q, [--quiet]</tt>:: Supress status output
    # <tt>-p, [--pretend]</tt>:: Run but do not make any changes
    # <tt>-s, [--skip]</tt>:: Skip files that already exist
    # <tt>-f, [--force]</tt>:: Overwrite files that already exist
    #
    # === Test framework options
    # <tt>[--testunit]</tt>:: Use test/unit for test files.
    # <tt>[--shoulda]</tt>:: Use shoulda for test files.
    # <tt>[--rspec]</tt>:: Use RSpec for test files.
    # <tt>[--skip-tests]</tt>:: Don't generate test files.
    #
    # === Examples
    #   rails generate humpyard:element SimpleText text:string 
    #   rails generate humpyard:element another_thing content:text --skip-tests
    # 
    # 
    class ElementGenerator < Base 
      include Rails::Generators::Migration

      argument :element_name, :type => :string, :required => true, :banner => 'ElementName'
      argument :model_attributes, :type => :array, :default => [], :banner => 'field:type field:type'

      class_option :skip_model, :desc => 'Don\'t generate a model or migration file.', :type => :boolean
      class_option :skip_migration, :desc => 'Dont generate migration file for model.', :type => :boolean
      class_option :skip_timestamps, :desc => 'Don\'t add timestamps to migration file.', :type => :boolean
      class_option :skip_views, :desc => 'Don\'t generate view files.', :type => :boolean
      
      class_option :skip_tests, :desc => 'Don\'t generate test files.', :group => 'Test framework', :type => :boolean
      class_option :testunit, :desc => 'Use test/unit for test files.', :group => 'Test framework', :type => :boolean
      class_option :rspec, :desc => 'Use RSpec for test files.', :group => 'Test framework', :type => :boolean
      class_option :shoulda, :desc => 'Use shoulda for test files.', :group => 'Test framework', :type => :boolean

      def create_element # :nodoc:        
        unless options.skip_model?
          template 'model.rb', "app/models/#{singular_name}.rb"
          unless options.skip_tests?
            case test_framework
            when :rspec
              template "tests/rspec/model.rb", "spec/models/#{singular_name}_spec.rb"
              template 'fixtures.yml', "spec/fixtures/#{plural_name}.yml"
            when :shoulda
              template "tests/shoulda/model.rb", "test/models/#{singular_name}_test.rb"
              template 'fixtures.yml', "test/fixtures/#{plural_name}.yml"
            when :testunit
              template "tests/#{test_framework}/model.rb", "test/unit/#{singular_name}_test.rb"
              template 'fixtures.yml', "test/fixtures/#{plural_name}.yml"
            end
          end
        end
        
        unless options.skip_views?
          template '_inline_edit.html.haml', "app/views/humpyard/elements/#{plural_name}/_inline_edit.html.haml"
          template '_edit.html.haml', "app/views/humpyard/elements/#{plural_name}/_edit.html.haml"
          template '_show.html.haml', "app/views/humpyard/elements/#{plural_name}/_show.html.haml"
        end

        unless options.skip_model? || options.skip_migration?
          migration_template 'migration.rb', "db/migrate/create_#{plural_name.gsub('/','_')}.rb"
        end
      end

      private
      
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
        "#{element_name.camelize}Element"
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
        elsif options.testunit?
          return @test_framework = :testunit
        elsif options.shoulda?
          return @test_framework = :shoulda
        else
          return @test_framework = default_test_framework
        end
      end

      def default_test_framework
        File.exist?(destination_path("spec")) ? :rspec : :testunit
      end

      def destination_path(path)
        File.join(destination_root, path)
      end

      # Implement the required interface for Rails::Generators::Migration.
      #
      def self.next_migration_number(dirname) #:nodoc:
        if ::ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end

    end
  end
end
