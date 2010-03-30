require 'pickle'

Given /^the standard pages$/ do
# TODO: Problem with globalize2 when not setting the AR locale to a definite locale.
#       Keep an eye on it and hope for fixes for globalize2 and rails3.
#       I will contact Sven Fuchs the next days.
#  
#  old_locale = I18n.locale
#  I18n.locale = :en
  Humpyard::Page.locale = :en
  Humpyard::Elements::TextElement.locale = :en
  
  Factory :page, :id => 42, :name => 'index', :title => 'My Homepage', :position => 1
  Factory :page, :id => 45, :name => 'about', :title => 'About', :position => 4
  Factory :page, :id => 60, :name => 'contact', :title => 'Contact', :parent_id => 45
  Factory :page, :id => 89, :name => 'imprint', :title => 'Imprint', :position => 2
  
  t1 = Factory :text_element, :content => 'This is some great text!', :page_id => 42, :position => 2
  c = Factory :container_element, :page_id => 42, :position => 1
  t2 = Factory :text_element, :content => 'This is text inside a container', :container => c, :position => 1
  
#  I18n.locale = :de
  Humpyard::Page.locale = :de
  Humpyard::Page.find(42).update_attributes(:title => 'Meine Startseite')
#  I18n.locale = old_locale
  Humpyard::Elements::TextElement.locale = :de
  t1.update_attribute :content, 'Dies ist ein super Text!'
  t2.update_attribute :content, 'Dies ist ein Text in einem Container'
  
  Humpyard::Page.locale = nil
  Humpyard::Elements::TextElement.locale = nil
end

Given /^I am logged in as (.+)$/ do |user|
  visit "/?user=#{user}"
end

Given /^the following (.+) records?$/ do |factory, table|  
  table.hashes.each do |hash|  
    Factory(factory, hash)  
  end  
  #puts Humpyard::Page.all.inspect
end

Given /^the configured www prefix is "([^\"]*)"$/ do |www_prefix|
  Humpyard::config.www_prefix = (www_prefix == ':default' ? nil : www_prefix)
  Rails::Application.reload_routes!
end

Given /^the configured locales is "([^\"]*)"$/ do |locales|
  Humpyard::config.locales = (locales == ':default' ? nil : locales)
  Rails::Application.reload_routes!
end

Given /^the current locale is "([^\"]*)"$/ do |locale|
  I18n.locale = (locale == ':default' ? nil : locale)
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

Then /^I should get a status code of (\d*)$/ do |status_code|
  page.driver.last_response.status.should == status_code.to_i
end
