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
  
  #Humpyard::Page.destroy_all
  
  
  page = Factory.build :static_page, :name => 'index', :title => 'My Homepage', :position => 1
  page.page.id = 42
  page.save
  page = Factory.build :static_page, :name => 'about', :title => 'About', :position => 4
  page.page.id = 45
  page.save
  page = Factory.build :static_page, :name => 'contact', :title => 'Contact', :parent_id => 45
  page.page.id = 60
  page.save
  page = Factory.build :static_page, :name => 'imprint', :title => 'Imprint', :position => 2
  page.page.id = 89
  page.save
  page = Factory.build :static_page, :name => 'alternative-layout-test', :title => 'Special page', :position => 5, :template_name => "alternative"
  page.page.id = 11
  page.save
    
  t1 = Factory :text_element, :content => 'This is some great text!', :page_id => 42, :position => 2
  c = Factory :box_element, :title => 'This is a box element', :page_id => 42, :position => 1
  t2 = Factory :text_element, :content => 'This is text inside a container', :container => c.element, :position => 1
  
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


When /^I click on "([^\"]*)" within "([^\"]*)"$/ do |link_text, selector|
  within(:css, selector) do
    find_link(link_text).click()
  end
end

When /^I hover over the css element "([^\"]*)"$/ do |selector|
  res = page.evaluate_script("window.setTimeout (function() {$('#{selector}').trigger('mouseover');}, 1)")
end

When /^I edit the page "([^\"]*)"$/ do |page_url|
  visit page_url
  within(:css, "#hy-top") do
    find_link("Edit").click()
  end
end

When /^I edit the css element "([^\"]*)"$/ do |selector|
  page.evaluate_script("window.setTimeout (function() {$('#{selector}').trigger('mouseover');}, 1)")
  within(:css, selector) do
    wait_until { find_link("Edit").visible? }
    find_link("Edit").click()
  end
  page.evaluate_script("window.setTimeout (function() {$('#{selector}').trigger('mouseout');}, 1)")
  dialog = wait_until{find(:css, ".ui-dialog")}
  dialog.visible?.should == true
  wait_until(15){ has_css?(".ui-dialog form") }.should == true
end

When /^I change the field "([^\"]*)" to "([^\"]*)"$/ do |attr, new_content|
  within(:css, ".ui-dialog form") do
    fill_in "element[#{attr}]", :with => new_content
  end
end

When /^I click "([^\"]*)" on the dialog$/ do |button_title|
  within(:css, ".ui-dialog") do
    click(button_title)
  end
end


Then /^put me the raw result$/ do
  # Only use this for debugging a output if you don't know what went wrong
  raise page.body
end

Then /^I should get a status code of (\d*)$/ do |status_code|
  page.driver.last_response.status.should == status_code.to_i
end

Then /^I should see a css element "([^\"]*)"$/ do |selector|
  page.has_css?(selector).should == true
end

Then /^I should see a button named "([^\"]*)" within "([^\"]*)"$/ do |name, selector|
  within(:css, selector) do
    but = find_link(name)
    but.should_not == nil
    but.visible?.should == true
  end
end

Then /^I should see \/([^\/]*)\/(?: within css element "([^\"]*)")?$/ do |re, scope_selector|
  regexp = Regexp.new(re)
  within(:css, scope_selector) do
    wait_until(15) { find(:css, ".text-element").text.match(regexp) rescue false }.should_not == nil
  end
end


Then /^the css element "([^\"]*)" should be within the window boundaries$/ do |selector|
  el = page.find(:css, selector)
  el_pos = page.evaluate_script('$("'+selector+'").offset()');
  el_height = page.evaluate_script('$("'+selector+'").height()');
  el_width = page.evaluate_script('$("'+selector+'").width()');
  win_height = page.evaluate_script('$(window).height()')
  win_width = page.evaluate_script('$(window).width()')
  if el_pos[:top].to_i >= win_height.to_i
    raise "top of element '#{selector}' is greater than the window height of #{win_height}"
  end
  if el_pos[:left].to_i >= win_width.to_i
    raise "left of element '#{selector}' is greater than the window height of #{win_height}"
  end
  if el_pos[:left].to_i + el_width.to_i < 0
    raise "left+width of element '#{selector}' is less than 0"
  end
  if el_pos[:top].to_i + el_height.to_i < 0
    raise "top+height of element '#{selector}' is less than 0"
  end
end

Then /^the dialog should be open$/ do
  wait_until(15) { page.has_css?(".ui-dialog") }.should == true
end

Then /^the dialog should be closed$/ do
  wait_until(15) { not page.has_css?(".ui-dialog") }.should == true
end

Then /^I should see the error "([^\"]*)" on the field "([^\"]*)"$/ do |msg, attr|
  within(:css, ".ui-dialog .attr_#{attr}") do
    wait_until(15) { find(:css, ".field-errors").text == msg rescue false }.should_not == nil
  end
end

When /^I switch to the dialog tab "([^\"]*)"$/ do |tabtitle|
  wait_until(15) { page.has_css?(".ui-dialog") }.should == true
  within(:css, ".ui-dialog") do
    link = find_link(tabtitle)
    link.click
    puts link['href']
    wait_until { find(:css, link['href']).visible? }.should == true
  end
end

