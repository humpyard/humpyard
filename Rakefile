require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'humpyard'
    gem.summary = %Q{Humpyard is a Rails CMS}
    gem.description = %Q{Humpyard is a Rails CMS}
    gem.email = 'broenstrup@spom.net'
    gem.homepage = 'http://github.com/humpyard/humpyard'
    gem.authors = ['Sven G. Broenstrup']
    gem.add_development_dependency 'rspec', '>= 1.2.9'
    gem.add_development_dependency 'cucumber', '>= 0.6.3'
    gem.add_development_dependency 'cucumber-rails', '>= 0.3.0'
    gem.add_development_dependency 'pickle', '>= 0.2.4'
    gem.add_development_dependency 'capybara', '>= 0.3.5'
    gem.add_development_dependency 'factory_girl', '>= 1.2.3'
    gem.add_development_dependency 'markup_validity', '>= 1.1.0'
    gem.add_dependency 'builder'
    gem.add_dependency 'rails', '>= 3.0.0.beta'
    gem.add_dependency 'haml', '>= 2.2.20'
    gem.add_dependency 'acts_as_tree', '>= 0.1.1'
    gem.files = Dir["{lib}/**/*", "{app}/**/*", "{config}/routes.rb", "{config}/locales/*", "{db}/migrate/*", "VERSION", "README*", "LICENCE"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: gem install jeweler'
end

# require 'spec/rake/spectask'
# Spec::Rake::SpecTask.new(:spec) do |spec|
#   spec.libs << 'lib' << 'spec'
#   spec.spec_files = FileList['spec/**/*_spec.rb']
# end
#
# Spec::Rake::SpecTask.new(:rcov) do |spec|
#   spec.libs << 'lib' << 'spec'
#   spec.pattern = 'spec/**/*_spec.rb'
#   spec.rcov = true
# end
# 
# task :spec => :check_dependencies

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)

  task :features => :check_dependencies
rescue LoadError
  task :features do
    abort 'Cucumber is not available. In order to run features, you must: sudo gem install cucumber'
  end
end

task :default => :features

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "humpyard #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :db do
  desc "Migrate the test database through scripts in db/migrate. Target specific version with VERSION=x. Turn off output with VERBOSE=false."
  task :migrate do
    require 'test/fake_rails'
    autoload :Humpyard, 'humpyard'
    ActiveRecord::Base.table_name_prefix = Humpyard::config.table_name_prefix
    ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
    ActiveRecord::Migrator.migrate("#{File.dirname(__FILE__)}/db/migrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  end
end

desc 'Print out all defined routes in match order, with names. Target specific controller with CONTROLLER=x.'
task :routes do
  require 'test/fake_rails'
  autoload :Humpyard, 'humpyard'
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