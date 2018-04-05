# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "humpyard"
  s.summary = "Humpyard is a Rails CMS"
  s.description = "Humpyard is a Rails CMS"
  s.authors = ["Sven G. Broenstrup", "Andreas Pieper"]
  s.email = 'info@humpyard.org'
  s.homepage = 'http://humpyard.org/'
  s.files = Dir.glob("lib/**/*") + Dir.glob("app/**/*") + Dir.glob("config/**/*") + Dir.glob("db/migrate/*") + ["MIT-LICENSE", "Rakefile", "README.rdoc", "script/rails"]
  s.add_dependency 'rails', '>= 3.1.0'
  s.add_dependency 'coffee-script', '>= 2.2.0'
  s.add_dependency 'sass-rails', '>= 3.1.0'
  s.add_dependency 'haml-rails', '>= 0.3.4'
  s.add_dependency 'acts_as_tree', '~> 0.1'
  s.add_dependency 'globalize3', '>= 0.2.0'
  s.add_dependency 'cancan', '>= 1.6.4'
  s.add_dependency 'humpyard_form', '>= 0.1.0'
  s.version = "0.1.0"
end
