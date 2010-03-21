require 'spec_helper'

describe Humpyard::Elements::TextElement do
  it "creates a new text element from factory" do
    e = Factory.build(:text_element, :page => Factory.build(:page))
    e.valid?.should eql true
  end
end