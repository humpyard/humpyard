require 'pickle'

Transform /^table:(?:.*,)?parent(?:,.*)?$/i do |table|
  table.map_headers! { |header| header.downcase }
  table.map_column!("parent") { |a| model(a) }
  table
end

Given /^the following (.+) records?$/ do |factory, table|  
  table.hashes.each do |hash|  
    Factory(factory, hash)  
  end  
  #puts Humpyard::Page.all.inspect
end

Given /^#{capture_model} is the parent of #{capture_model}$/ do |parent, child|
  child = model(child)
  child.parent = model(parent)
  child.save!
end

Given /^I am logged in as (.+)$/ do |user|
  visit "/?user=#{user}"
end

Given /^I am not logged in$/ do 
  visit "/?user="
end

Given /^the configured www prefix is "([^\"]*)"$/ do |www_prefix|
  Humpyard::config.www_prefix = (www_prefix == ':default' ? nil : www_prefix)
  TestHumpyard::Application.reload_routes!
end

Given /^the configured locales is "([^\"]*)"$/ do |locales|
  Humpyard::config.locales = (locales == ':default' ? nil : locales)
  TestHumpyard::Application.reload_routes!
end

Given /^the current locale is "([^\"]*)"$/ do |locale|
  I18n.locale = (locale == ':default' ? nil : locale)
end


