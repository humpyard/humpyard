Given /^the standard pages$/ do
  old_locale = I18n.locale
  I18n.locale = :en
  
  Humpyard::Page.destroy_all
  
  page = Factory.build :static_page, :title => 'My Homepage', :position => 1
  page.page.id = 42
  page.save
  page = Factory.build :static_page, :title => 'About', :position => 4
  page.page.id = 45
  page.save
  page = Factory.build :static_page, :title => 'Contact', :parent_id => 45
  page.page.id = 60
  page.save
  page = Factory.build :static_page, :title => 'Imprint', :position => 2
  page.page.id = 89
  page.save
  page = Factory.build :static_page, :title => 'Special page', :position => 5, :template_name => "alternative"
  page.page.id = 11
  page.save
    
  t1 = Factory :text_element, :content => 'This is some great text!', :page_id => 42, :position => 2
  c = Factory :box_element, :title => 'This is a box element', :page_id => 42, :position => 1
  t2 = Factory :text_element, :content => 'This is text inside a container', :container => c.element, :position => 1
  
  I18n.locale = :de
  Humpyard::Page.find(42).update_attributes(:title => 'Meine Startseite')
  t1.update_attribute :content, 'Dies ist ein super Text!'
  t2.update_attribute :content, 'Dies ist ein Text in einem Container'
  I18n.locale = old_locale
end

When /^I edit the page "([^\"]*)"$/ do |page_url|
  visit page_url
  within(:css, "#hy-top") do
    find_link("Edit").click()
  end
end

When /^I edit the element "([^\"]*)"$/ do |selector|
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

Then /^I should see the page with id (\d*)$/ do |page_id|
  # "#{page.body}".slice(/X-HumpYard-Page:(\d*)/).gsub(/^X-HumpYard-Page:(\d*)$/, '\1').should == page_id
  page.driver.last_response.headers['X-Humpyard-Page'].should == page_id
end

Then /the sitemap should contain correct lastmod entry for page with id (\d+)/ do |page_id|
  p = Humpyard::Page.find page_id
  url = "http://www.example.com#{p.human_url}"
  lastmod = p.last_modified.to_time.strftime("%FT%T%z").gsub(/00$/,':00')
  sitemap = Nokogiri::XML("#{page.body}")
  sitemap.css("urlset url").each do |el|
    loc = el.css("loc").text
    if loc == url
      lastmod.should == el.css("lastmod").text
    end
  end
end

