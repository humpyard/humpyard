When /^I switch to the dialog tab "([^\"]*)"$/ do |tabtitle|
  wait_until(15) { page.has_css?(".ui-dialog") }.should == true
  within(:css, ".ui-dialog") do
    link = find_link(tabtitle)
    link.click
    puts link['href']
    wait_until { find(:css, link['href']).visible? }.should == true
  end
end

Then /^the dialog should be open$/ do
  wait_until(15) { page.has_css?(".ui-dialog") }.should == true
end

Then /^the dialog should be closed$/ do
  wait_until(15) { not page.has_css?(".ui-dialog") }.should == true
end

