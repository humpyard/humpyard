require 'spec_helper'

describe Humpyard::PagesHelper do
  include Humpyard::PagesHelper
  describe "title" do
    it "sets @show_title and @content_for_title" do
      title("page title")
      @content_for_title.should eql "page title"
    end
  end
  
  describe "stylesheet" do
    it "should create a proper stylesheet link"
  end
  
  describe "javascript" do
    it "should create a proper javascript link"
  end
  
end