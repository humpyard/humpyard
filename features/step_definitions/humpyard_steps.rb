require 'pickle'

Given /^the standard pages$/ do
  Factory :page, :id => 42, :name => 'index', :title => 'My Homepage', :position => 1
  Factory :page, :id => 45, :name => 'about', :title => 'About', :position => 4
  Factory :page, :id => 60, :name => 'contact', :title => 'Contact', :parent_id => 45
  Factory :page, :id => 89, :name => 'imprint', :title => 'Imprint', :position => 2
end

Given /^the following (.+) records?$/ do |factory, table|  
  table.hashes.each do |hash|  
    Factory(factory, hash)  
  end  
  #puts Humpyard::Page.all.inspect
end

Given /^the www prefix is "([^\"]*)"$/ do |www_prefix|
  Humpyard::config.www_prefix = (www_prefix == ':default' ? nil : www_prefix)
  Rails::Application.reload_routes!
end

Transform /^table:(?:.*,)?parent(?:,.*)?$/i do |table|
  table.map_headers! { |header| header.downcase }
  table.map_column!("parent") { |a| model(a) }
  table
end

Given /^#{capture_model} is the parent of #{capture_model}$/ do |parent, child|
  child = model(child)
  child.parent = model(parent)
  child.save!
end



Then /^put me the raw result$/ do
  # Only use this for debugging a output if you don't know what went wrong
  raise page.body
end

Then /^I should get a status code of "([^\"]*)"$/ do |status_code|
  page.driver.last_response.status.to_s.should == status_code
end
