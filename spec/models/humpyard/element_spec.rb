require 'spec_helper'

describe Humpyard::Element do
  it "creates a new element from factory" do
    e = Factory.build(:element)
    e.valid?.should eql true
  end
end