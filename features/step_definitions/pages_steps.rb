Then /^I should see the page with id (\d*)$/ do |page_id|
  "#{page.body}".slice(/X-HumpYard-Page:(\d*)/).gsub(/^X-HumpYard-Page:(\d*)$/, '\1').should == page_id
end
