#require 'rake/remote_task'
require "hump_yard"

namespace :hump_yard do  
  namespace :db do
    desc "Migrate the database through scripts in db/migrate and update db/schema.rb by invoking db:schema:dump. Target specific version with VERSION=x. Turn off output with VERBOSE=false."
    task :migrate => :environment do
      ActiveRecord::Base.table_name_prefix = HumpYard::config.table_name_prefix
      ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
      ActiveRecord::Migrator.migrate("#{File.dirname(__FILE__)}/../../db/migrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
      Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
    end  
  
    namespace :migrate do
      desc  'Rollbacks the database one migration and re migrate up. If you want to rollback more than one step, define STEP=x. Target specific version with VERSION=x.'
      task :redo => :environment do
        ActiveRecord::Base.table_name_prefix = HumpYard::config.table_name_prefix
        if ENV["VERSION"]
          Rake::Task["hump_yard:db:migrate:down"].invoke
          Rake::Task["hump_yard:db:migrate:up"].invoke
        else
          Rake::Task["hump_yard:db:rollback"].invoke
          Rake::Task["hump_yard:db:migrate"].invoke
        end
      end

      desc 'Runs the "up" for a given migration VERSION.'
      task :up => :environment do
        ActiveRecord::Base.table_name_prefix = HumpYard::config.table_name_prefix
        version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
        raise "VERSION is required" unless version
        ActiveRecord::Migrator.run(:up, "#{File.dirname(__FILE__)}/../../db/migrate/", version)
        Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
      end

      desc 'Runs the "down" for a given migration VERSION.'
      task :down => :environment do
        ActiveRecord::Base.table_name_prefix = HumpYard::config.table_name_prefix
        version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
        raise "VERSION is required" unless version
        ActiveRecord::Migrator.run(:down, "#{File.dirname(__FILE__)}/../../db/migrate/", version)
        Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
      end
    end

    desc 'Rolls the schema back to the previous version. Specify the number of steps with STEP=n'
    task :rollback => :environment do
      ActiveRecord::Base.table_name_prefix = HumpYard::config.table_name_prefix
      step = ENV['STEP'] ? ENV['STEP'].to_i : 1
      ActiveRecord::Migrator.rollback("#{File.dirname(__FILE__)}/../../db/migrate/", step)
      Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
    end

    desc 'Pushes the schema to the next version. Specify the number of steps with STEP=n'
    task :forward => :environment do
      ActiveRecord::Base.table_name_prefix = HumpYard::config.table_name_prefix
      step = ENV['STEP'] ? ENV['STEP'].to_i : 1
      ActiveRecord::Migrator.forward("#{File.dirname(__FILE__)}/../../db/migrate/", step)
      Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
    end

    desc "Retrieves the current schema version number"
    task :version => :environment do
      ActiveRecord::Base.table_name_prefix = HumpYard::config.table_name_prefix
      puts "Current version: #{ActiveRecord::Migrator.current_version}"
    end

    desc "Raises an error if there are pending migrations"
    task :abort_if_pending_migrations => :environment do
      ActiveRecord::Base.table_name_prefix = HumpYard::config.table_name_prefix
      if defined? ActiveRecord
        pending_migrations = ActiveRecord::Migrator.new(:up, "#{File.dirname(__FILE__)}/../../db/migrate/").pending_migrations

        if pending_migrations.any?
          puts "You have #{pending_migrations.size} pending migrations:"
          pending_migrations.each do |pending_migration|
            puts '  %4d %s' % [pending_migration.version, pending_migration.name]
          end
          abort %{Run "rake hump_yard:db:migrate" to update your database then try again.}
        end
      end
    end
  end
end