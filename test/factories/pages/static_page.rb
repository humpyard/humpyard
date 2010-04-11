Factory.define :static_page, :class => Humpyard::Pages::StaticPage do |p|
  p.title 'Some Static Page'
  p.sequence(:name) {|n| "static_page_#{n}"}
end