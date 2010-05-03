puts 'Init FactoryGirl'
require 'factory_girl'
Dir.glob(File.join(File.dirname(__FILE__), '../../test/factories/**/*.rb')).each {|f| require f }  
