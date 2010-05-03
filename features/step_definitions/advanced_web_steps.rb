When /^I hover over "([^\"]*)"$/ do |selector|
  res = page.evaluate_script("window.setTimeout (function() {$('#{selector}').trigger('mouseover');}, 1)")
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

Then /^I should see the error "([^\"]*)" on the field "([^\"]*)"$/ do |msg, attr|
  within(:css, ".ui-dialog .attr_#{attr}") do
    wait_until(15) { find(:css, ".field-errors").text == msg rescue false }.should_not == nil
  end
end