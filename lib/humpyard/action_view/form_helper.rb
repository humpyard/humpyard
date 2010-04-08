module Humpyard
  module ActionView
    module FormHelper
      def humpyard_form_for(record, options={}, &block)
        form = Humpyard::FormBuilder.new(self, record, options)
        inner_haml = capture_haml(form, &block)
        render :partial => '/humpyard/forms/form', :locals => {:form => form, :inner_haml => inner_haml}
      end
      
      # execute a block with a given locale
      def with_locale(locale, &block)
        old_locale = I18n.locale
        I18n.locale = locale
        yield(locale)
        I18n.locale = old_locale
      end
      
    end
  end
end

ActionView::Base.send :include, Humpyard::ActionView::FormHelper