require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "hump_yard"
    gem.summary = %Q{HumpYard is a Rails CMS}
    gem.description = %Q{HumpYard is a Rails CMS}
    gem.email = "broenstrup@spom.net"
    gem.homepage = "http://github.com/starpeak/hump_yard"
    gem.authors = ["Sven G. Broenstrup"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "cucumber", ">= 0"
    gem.add_dependency 'rails', '>= 3.0.0.beta'
    gem.add_dependency 'haml'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
    #gem.files = FileList['lib/**/*.rb', 'app/**/*.rb', 'app/views/**/*.haml', 'app/views/**/*.erb', 'locales/*.yml', 'bin/*', '[A-Z]*', 'spec/**/*', 'features/**/*'].to_a
    gem.files = Dir["{lib}/**/*", "{app}/**/*", "{config}/**/*", "{db}/migrate/*", "{features}/**/*", "{specs}/**/*"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)

  task :features => :check_dependencies
rescue LoadError
  task :features do
    abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
  end
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "hump_yard #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
