# encoding: UTF-8
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/test/rails/config/environment")

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

#Rails::Application.railties.all.each do |test|
#  test.load_tasks if test.class == Rails::TestUnitRailtie
#end

Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'HumpYard'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('doc/**/*.rdoc', 'lib/**/*.rb', 'app/*/humpyard/**/*.rb')
  rdoc.rdoc_files.exclude('lib/generators/**/templates/**/*.rb')
end

begin
  require 'rspec'
  require 'rspec/core/rake_task'

  Rspec::Core::RakeTask.new(:spec)
  
  namespace :spec do
    desc "Run specs to generate coverage"
    Rspec::Core::RakeTask.new(:rcov) do |spec|
      spec.rcov = true
      spec.rcov_opts = %[--exclude "core,expectations,gems/*,spec/resources,spec/spec,spec/spec_helper.rb,db/*,/Library/Ruby/*,config/*" --text-summary  --sort coverage]
    end
  end
  
  task :spec => [:'db:test:reset']
rescue
  task :spec do
    abort 'Spec is not available. In order to run cucumber, you must: sudo gem install rspec'
  end
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:cucumber)
  
  namespace :cucumber do
    desc "Run cucumber to generate coverage"
    Cucumber::Rake::Task.new(:rcov) do |cucumber|    
      cucumber.rcov = true
      cucumber.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/,features\/,test\/ --aggregate coverage.data}
      cucumber.rcov_opts << %[-o "coverage"]
    end
  end

  task :cucumber => [:'db:test:reset']
rescue LoadError
  task :cucumber do
    abort 'Cucumber is not available. In order to run cucumber, you must: sudo gem install cucumber'
  end
end

desc "Run RSpec and Cucumber tests"
task :test => [:spec, :cucumber]
task :default => :test
 
desc "Run both rspec and cucumber tests to generate aggregated coverage"
task :rcov do |t|
  rm "coverage.data" if File.exist?("coverage.data")
  Rake::Task['spec:rcov'].invoke
  Rake::Task["cucumber:rcov"].invoke
  `open #{File.dirname(__FILE__)}/coverage/index.html`
end

namespace :db do
  namespace :test do
    desc "Migrate the test database through scripts in db/migrate. Target specific version with VERSION=x. Turn off output with VERBOSE=false."
    task :prepare do
      ActiveRecord::Base.configurations = Rails::Application.config.database_configuration      
      class ActiveRecord::Base
         self.table_name_prefix = "#{::ActiveRecord::Base.table_name_prefix}#{Humpyard::config.table_name_prefix}"
      end
      
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
      ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
      ActiveRecord::Migrator.migrate("#{File.dirname(__FILE__)}/db/migrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
    end
    desc "Remove the test database"
    task :drop do
      require 'pathname'
      config = Rails::Application.config.database_configuration['test']
      path = Pathname.new(config['database'])
      file = path.absolute? ? path.to_s : File.join(Rails.root, path)

      FileUtils.rm(file)
    end
    desc "Reset the test database and prepare it through scripts in db/migrate"
    task :reset => [:drop, :prepare]
  end
end

desc 'Print out all defined routes in match order, with names. Target specific controller with CONTROLLER=x.'
task :routes do
  ENV["RAILS_ENV"] = "test"
  require File.expand_path(File.dirname(__FILE__) + "/config/environment")
  
  Rails::Application.reload_routes!
  all_routes = ENV['CONTROLLER'] ? ActionController::Routing::Routes.routes.select { |route| route.defaults[:controller] == ENV['CONTROLLER'] } : ActionController::Routing::Routes.routes
  routes = all_routes.collect do |route|
    name = ActionController::Routing::Routes.named_routes.routes.index(route).to_s
    reqs = route.requirements.empty? ? "" : route.requirements.inspect
    {:name => name, :verb => route.verb.to_s, :path => route.path, :reqs => reqs}
  end
  routes.reject!{ |r| r[:path] == "/rails/info/properties" } # skip the route if it's internal info route
  name_width = routes.collect {|r| r[:name]}.collect {|n| n.length}.max
  verb_width = routes.collect {|r| r[:verb]}.collect {|v| v.length}.max
  path_width = routes.collect {|r| r[:path]}.collect {|s| s.length}.max
  routes.each do |r|
    puts "#{r[:name].rjust(name_width)} #{r[:verb].ljust(verb_width)} #{r[:path].ljust(path_width)} #{r[:reqs]}"
  end
end

spec = Gem::Specification.new do |s|
  s.name = "humpyard"
  s.summary = %Q{Humpyard is a Rails CMS}
  s.description = %Q{Humpyard is a Rails CMS}
  s.email = 'info@humpyard.org'
  s.homepage = 'http://humpyard.org/'
  s.authors = ['Sven G. Broenstrup', 'Andreas Pieper']
  s.files = Dir["{lib}/**/*", "{app}/*/humpyard/**/*", "{config}/routes.rb", "{config}/locales/*", "{db}/migrate/*", "{compass}/**/*", "VERSION", "README*", "LICENCE", "Gemfile"]
  s.version = ::File.read(::File.join(::File.dirname(__FILE__), "VERSION")).strip
  s.add_dependency 'builder'
  s.add_dependency 'rails', '>= 3.0.0'
  s.add_dependency 'haml', '>= 3.0.0'
  s.add_dependency 'compass', '>=0.10.0'
  s.add_dependency 'acts_as_tree', '>= 0.1.1'
  s.add_dependency 'cancan', '>= 1.3.4'
  s.add_dependency 'globalize3', '>= 0.0.7'
  s.add_dependency 'humpyard_form', '>= 0.0.4'
end

Rake::GemPackageTask.new(spec) do |pkg|
end

desc "Create a stand-alone gemspec"
task :gemspec  do
  open("#{spec.name}.gemspec", "w") do |f| 
    f.puts "# Generated by rake\n# DO NOT EDIT THIS FILE DIRECTLY\n"
    f.puts spec.to_ruby 
  end
end

task :gem => [:gemspec]

desc "Install the gem #{spec.name}-#{spec.version}.gem"
task :install do
  system("gem install pkg/#{spec.name}-#{spec.version}.gem --no-ri --no-rdoc")
end
task :install => [:gem]
