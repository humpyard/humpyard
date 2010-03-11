$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rails/all'

# Fake Rails deps
module ApplicationHelper
end

class ApplicationController < ActionController::Base
  protect_from_forgery
end

require 'hump_yard'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end
