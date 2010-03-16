Then /^the page is valid XML$/ do 
  Nokogiri::XML("#{page.body}") { |config| config.options = Nokogiri::XML::ParseOptions::STRICT }
end

Then %r/the page is valid XHTML/ do
  page.body.should be_xhtml_transitional 
end

Then %r/the page is valid strict XHTML/ do
  page.body.should be_xhtml_strict 
end
