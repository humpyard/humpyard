require 'spec_helper'

describe Humpyard::Elements::TextElement do

  before(:all) do
    @rails_root_mtime = Time.zone.at(::File.new("#{Rails.root}").mtime)
  end
  
  it "creates a new text element from factory" do
    e = Factory.build(:text_element, :page => Factory.build(:page))
    e.valid?.should eql true
  end
  
  # last_modified tests
  it "responds to last_modified with the mtime of Rails.root if it is younger than itself" do
    te = Factory(:text_element, :updated_at => @rails_root_mtime - 2.minutes)
    e = Factory(:element, :updated_at => @rails_root_mtime - 2.minutes, :content_data => te)
    e.last_modified.should eql (@rails_root_mtime)
  end
  
  it "responds to last_modified with the element's updated_at" do
    te = Factory(:text_element, :updated_at => @rails_root_mtime + 2.minutes)
    e = Factory(:element, :updated_at => @rails_root_mtime + 2.minutes, :content_data => te)
    e.last_modified.should eql e.updated_at
  end

  it "updates last_modified if content_data is updated" do
    # pending does not work??
    #pending "missing callbacks to element in acts_as_humpyard_element" do
      te = Factory(:text_element, :updated_at => @rails_root_mtime + 2.minutes)
      e = Factory(:element, :updated_at => @rails_root_mtime + 2.minutes, :content_data => te)
      te.content = "updated text content"
      te.save
      # this is missing in the model. that beacuse the test fails:
      #e.touch
      e.reload
      e.last_modified.should > @rails_root_mtime + 2.minutes
    #end
  end

end