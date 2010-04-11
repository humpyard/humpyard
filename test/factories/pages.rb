Factory.define :page, :class => Humpyard::Page do |factory|
  factory.title 'Some Page'
  factory.sequence(:name) {|n| "page_#{n}"} 
  #factory.association :content_data, :factory => :static_page
end