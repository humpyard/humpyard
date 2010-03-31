require 'spec_helper'

describe Humpyard::Elements::BoxElement do
  it "creates a new box container element from factory" do
    c = Factory.build(:box_element, :page => Factory.build(:page))
    c.valid?.should eql true
  end
  
  it "has a child" do
    c = Factory(:box_element, :page => Factory.build(:page))
    t = Factory(:text_element, :container => c.element, :content => 'Some Text')
    c.valid?.should eql true
    t.valid?.should eql true
    t.container_id.should be c.element.id
    Humpyard::Element.where(:container_id => c.element).first.id.should be t.element.id
    c.elements.size.should eql 1
    c.elements.first.id.should be t.element.id
    c.elements << Factory(:text_element, :container => c.element, :content => 'Some other Text').element
    c.elements.size.should eql 2
  end
end