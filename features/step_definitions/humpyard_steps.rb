require 'pickle'

Given /^the following (.+) records?$/ do |factory, table|  
  table.hashes.each do |hash|  
    Factory(factory, hash)  
  end  
  #puts Humpyard::Page.all.inspect
end

Given /^the www prefix is "(.+)"$/ do |www_prefix|
  Humpyard::config.www_prefix = (www_prefix == :default ? nil : www_prefix)
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
  puts Humpyard::Page.all.inspect
end
