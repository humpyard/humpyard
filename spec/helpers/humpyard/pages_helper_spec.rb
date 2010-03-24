require 'spec_helper'

describe Humpyard::PagesHelper do
  include Humpyard::PagesHelper
  describe "title" do
    it "sets @show_title and @content_for_title" do
      title("page title", true)
      @content_for_title.should eql "page title"
      @show_title.should eql true
    end
  end
  
  describe "show_title" do
    it "should respond with the value of @show_title" do
      title("page title", true)
      show_title?.should eql true
      title("page title", false)
      show_title?.should eql false
    end
  end
  
  # describe "stylesheet" do
  #   it "should create a proper stylesheet link"
  # end
  # 
  # describe "javascript" do
  #   it "should create a proper javascript link"
  # end
  
end