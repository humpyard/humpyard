module Humpyard
  ####
  # Humpyard::FormHelper is a helper for forms in Humpyard 
  class FormBuilder 
    attr_reader :object, :options
    
    def initialize(renderer, object, options={})
      @renderer = renderer
      @object = object
      @options = options
    end
    
    def namespace
      if @options[:as]
        @options[:as]
      else
        @object.class.name.underscore.gsub('/', '_')
      end
    end
    
    def inputs
    end
    
    # def input(method, options = {})
    #   options[:required] = method_required?(method) unless options.key?(:required)
    #   options[:as]     ||= default_input_type(method)
    # 
    #   html_class = [ options[:as], (options[:required] ? :required : :optional) ]
    #   html_class << 'error' if @object && @object.respond_to?(:errors) && !@object.errors[method.to_sym].blank?
    # 
    #   wrapper_html = options.delete(:wrapper_html) || {}
    #   wrapper_html[:id]  ||= generate_html_id(method)
    #   wrapper_html[:class] = (html_class << wrapper_html[:class]).flatten.compact.join(' ')
    # 
    #   if options[:input_html] && options[:input_html][:id]
    #     options[:label_html] ||= {}
    #     options[:label_html][:for] ||= options[:input_html][:id]
    #   end
    # 
    #   input_parts = @@inline_order.dup
    #   input_parts.delete(:errors) if options[:as] == :hidden
    #   
    #   list_item_content = input_parts.map do |type|
    #     send(:"inline_#{type}_for", method, options)
    #   end.compact.join("\n")
    # 
    #   return template.content_tag(:li, list_item_content, wrapper_html)
    # end
    
    
    def input(method, options={}) #:nodoc:
      #options[:required] = method_required?(method) unless options.key?(:required)
      options[:as] ||= default_input_type(method)
      options[:translation_info] = translation_info(method)
      #puts options.inspect
      @renderer.render :partial => "/humpyard/forms/#{options[:as]}_input", :locals => {:form => self, :name => method, :options => options}
    end
    
    def submit(options={})
      @renderer.render :partial => '/humpyard/forms/submit', :locals => {:form => self, :options => options}
    end

    def translation_info(method) #:nodoc:
      if @object.respond_to?(:translated_attribute_names) and @object.translated_attribute_names.include?(method)
        tmp = @object.translation_class.new
        if tmp
          column = tmp.column_for_attribute(method) if tmp.respond_to?(:column_for_attribute)
          if column
            {:locales => Humpyard::config.locales, :column => column}
          end
        end
      else
        false
      end
    end
    
    # For methods that have a database column, take a best guess as to what the input method
    # should be.  In most cases, it will just return the column type (eg :string), but for special
    # cases it will simplify (like the case of :integer, :float & :decimal to :numeric), or do
    # something different (like :password and :select).
    #
    # If there is no column for the method (eg "virtual columns" with an attr_accessor), the
    # default is a :string, a similar behaviour to Rails' scaffolding.
    #
    def default_input_type(method) #:nodoc:
      column = @object.column_for_attribute(method) if @object.respond_to?(:column_for_attribute)
      
      # translated attributes dont have a column info at this point
      # check the associated translation class
      if not column
        tx_info = translation_info(method)
        if tx_info
          column = tx_info[:column]
        end
      end

      if column
        # handle the special cases where the column type doesn't map to an input method
        return :time_zone if column.type == :string && method.to_s =~ /time_zone/
        return :select    if column.type == :integer && method.to_s =~ /_id$/
        return :datetime  if column.type == :timestamp
        return :numeric   if [:integer, :float, :decimal].include?(column.type)
        return :password  if column.type == :string && method.to_s =~ /password/
        return :country   if column.type == :string && method.to_s =~ /country/

        # otherwise assume the input name will be the same as the column type (eg string_input)
        return column.type
      else
        # if @object
        #   return :select if find_reflection(method)
        # 
        #   file = @object.send(method) if @object.respond_to?(method)
        #   return :file   if file && @@file_methods.any? { |m| file.respond_to?(m) }
        # end

        return :password if method.to_s =~ /password/
        return :string
      end
    end
    
    
  end
end