Factory.define :page, :class => Humpyard::Page do |factory|
  factory.sequence(:title) {|n| "Some Page #{n}"} 
  #factory.association :content_data, :factory => :static_page
end