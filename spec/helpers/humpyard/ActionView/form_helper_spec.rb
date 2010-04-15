require 'spec_helper'


describe Humpyard::ActionView::FormHelper do
  include Humpyard::ActionView::FormHelper
  include ActionController::PolymorphicRoutes
  include ActionView::Helpers::RecordIdentificationHelper

  # DAMN! how to get a view context into the spec context?
  # then we would not have to stub all those methods below
  # and would be able to actually render something
  # and check if its right.
  
  describe '#humpyard__form_for' do

    it 'yields an instance of FormBuilder' do
      @page = mock_model(Humpyard::Page)
      self.stub!(:convert_to_model).and_return(Humpyard::Page)
      self.stub!(:humpyard_pages_path).and_return("/humpyard/pages")
      self.stub!(:capture_haml).and_return("Hepp")
      self.stub!(:render).and_return("Repp")
      humpyard_form_for(@page) do |builder|
        builder.class.should == ::Humpyard::FormBuilder
      end
    end
        
  end
end
