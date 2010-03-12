Given /^the following (.+) records?$/ do |factory, table|  
  table.hashes.each do |hash|  
    Factory(factory, hash)  
  end  
end

Given /^the www prefix is (.+)$/ do |www_prefix|
  Humpyard::config.www_prefix = www_prefix
  Rails::Application.reload_routes!
end