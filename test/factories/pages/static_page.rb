Factory.define :static_page, :class => Humpyard::Pages::StaticPage do |p|
  p.sequence(:title) {|n| "Some Static Page #{n}"}
end