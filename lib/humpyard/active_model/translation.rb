require 'active_model/translation'

module ActiveModel #:nodoc:
  module Translation #:nodoc:
    def human_attribute_name_with_namespaces(attribute, options = {})    
      # Namespace patch
      defaults = []
      lookup_ancestors.each do |klass|
        name = klass.model_name.underscore.split('/')
        while name.size > 0
          defaults << :"#{self.i18n_scope}.attributes.#{name * '.'}.#{attribute}"
          name.pop
        end
      end
    
      # Rails orig
      defaults << :"attributes.#{attribute}"
      defaults << options.delete(:default) if options[:default]
      defaults << attribute.to_s.humanize

      options.reverse_merge! :count => 1, :default => defaults
      I18n.translate(defaults.shift, options)
    end
    alias_method_chain :human_attribute_name, :namespaces
  end
end
