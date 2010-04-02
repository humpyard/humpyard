require 'spec_helper'

describe Humpyard::Element do
  it "creates a new element from factory" do
    e = Factory.build(:element)
    e.valid?.should eql true
  end
  
  it "is invalid if display_from is after display_until" do
    e = Factory.build(:element)
    e.display_from = Time.zone.now + 1.week
    e.display_until = Time.zone.now - 1.week
    e.valid?.should eql false
  end
  
  it "is valid if only display_from is set" do
    e = Factory.build(:element)
    e.display_from = Time.zone.now + 1.week
    e.valid?.should eql true
  end
  
  it "is valid if only display_unitl is set" do
    e = Factory.build(:element)
    e.display_until = Time.zone.now + 1.week
    e.valid?.should eql true
  end
  
  it "is valid if display_until is after display_from" do
    e = Factory.build(:element)
    e.display_from = Time.zone.now - 1.week
    e.display_until = Time.zone.now + 1.week
    e.valid?.should eql true
  end
  
end