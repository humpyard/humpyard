module Humpyard 
  module ActiveModel #:nodoc:
    module Name #:nodoc:
      def self.included(base)
        base.alias_method_chain :human, :namespaces
      end
      
      def human_with_namespaces(options={})
        # Rails orig
        return @human unless @klass.respond_to?(:lookup_ancestors) &&
                             @klass.respond_to?(:i18n_scope)

        # Namespace patch
        defaults = @klass.lookup_ancestors.map do |klass|
          klass.model_name.underscore.gsub('/','.').to_sym
        end
        
        # Rails orig
        defaults << options.delete(:default) if options[:default]
        defaults << @human

        options.reverse_merge! scope: [@klass.i18n_scope, :models], count: 1, default: defaults
        I18n.translate(defaults.shift, options)
      end
    end
  end
end

ActiveModel::Name.send :include, Humpyard::ActiveModel::Name