#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:cucumber)

desc "Run RSpec and Cucumber tests"
task :test => [:spec, :cucumber]
task :default => :test

namespace :doc do 
  begin
    require 'yard'
  
    YARD::Rake::YardocTask.new(:yard) do |t|
      t.files   = ['lib/**/*.rb', 'app/**/*.rb', '-', 'README.rdoc', 'MIT-LICENSE']
      t.options = ['--title', 'API - Humpyard', '--private', '--protected'] 
    end
  rescue
  end
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'