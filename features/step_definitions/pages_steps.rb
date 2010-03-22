Then /^I should see the page with id (\d*)$/ do |page_id|
  "#{page.body}".slice(/X-HumpYard-Page:(\d*)/).gsub(/^X-HumpYard-Page:(\d*)$/, '\1').should == page_id
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