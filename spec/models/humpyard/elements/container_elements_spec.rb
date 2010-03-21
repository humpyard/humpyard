require 'spec_helper'

describe Humpyard::Elements::ContainerElement do
  it "creates a new container element from factory" do
    c = Factory.build(:container_element, :page => Factory.build(:page))
    c.valid?.should eql true
  end
  
  it "has a child" do
    c = Factory(:container_element, :page => Factory.build(:page))
    t = Factory(:text_element, :container => c, :content => 'Some Text')
    c.valid?.should eql true
    t.valid?.should eql true
    t.container.should be c
    Humpyard::Element.where(:container_id => c).first.id.should be t.element.id
    c.elements.size.should eql 1
    c.elements.first.id.should be t.element.id
  end
end