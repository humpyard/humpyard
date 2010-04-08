Factory.define :page, :class => Humpyard::Page do |p|
  p.title 'Some Page'
  p.sequence(:name) {|n| "page_#{n}"} 
end