source 'http://gemcutter.org'

gem "rails",              :git => "git://github.com/rails/rails.git"
gem 'builder'
gem 'haml',               :git => 'git://github.com/nex3/haml.git'
gem 'compass',            :git => 'git://github.com/starpeak/compass.git'
gem 'acts_as_tree',       '>= 0.1.1'
gem 'cancan',             '>= 1.1.1'
gem 'globalize2',         :git => 'git://github.com/starpeak/globalize2.git' 

group :test do
  gem 'test-unit'
  gem 'rspec-rails',        '>= 2.0.0.beta.7' 
  gem 'capybara',           '>= 0.3.7' 
  gem 'database_cleaner',   '>= 0.5.2'     
  gem 'cucumber',           '= 0.6.4' #'> 0.7.0.beta.2' # as 0.7.2.beta.2 is not running for us
  gem 'cucumber-rails',     :git => 'git://github.com/aslakhellesoy/cucumber-rails.git'
  gem 'pickle',             '>= 0.2.4'
  gem 'capybara',           '>= 0.3.5'
  gem 'factory_girl',       '>= 1.2.3'
  gem 'markup_validity',    '>= 1.1.0'
  gem 'sqlite3-ruby',       :require => 'sqlite3'
  gem 'thin'
end

if RUBY_VERSION < '1.9'
  gem 'ruby-debug',         '>= 0.10.3'
end