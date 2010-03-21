Factory.define :text_element, :class => Humpyard::Elements::TextElement do |e|
  #e.page Factory.build(:page)
  e.content 'Some Content'
end