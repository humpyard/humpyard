module Humpyard
  module ActionView
    module FormHelper
      def humpyard_form_for(record, options={}, &block)
        inner_haml = capture_haml(Humpyard::FormBuilder.new(self, record, options), &block)
        render :partial => '/humpyard/forms/form', :locals => {:options => options, :inner_haml => inner_haml}
      end
    end
  end
end

ActionView::Base.send :include, Humpyard::ActionView::FormHelper