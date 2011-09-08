require 'spec_helper'

describe Humpyard::Elements::ContainerElement do
  it "creates a new box container element from factory" do
    c = Factory.build :container_element, :page => Factory.build(:page)
    c.valid?.should eql true
  end
  
  it "should handle children" do
    text_element = Factory.build :text_element, container: subject.element, content: 'Some Text'
    text_element.container_id.should be subject.element.id
    
    subject.elements.size.should eql 1
    subject.elements.first.id.should be text_element.element.id
    subject.elements << Factory(:text_element, :container => c.element, :content => 'Some other Text').element
    subject.elements.size.should eql 2
  end
end