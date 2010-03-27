module Humpyard
  module ActiveRecord
    module Acts
      module Element
        def self.included(base)
          base.has_one :element, :as => :content_data, :class_name => 'Humpyard::Element', :autosave => true
          base.validate :element_must_be_valid
          base.alias_method_chain :element, :autobuild 
          base.alias_method_chain :column_for_attribute, :element_column_for_attribute
   
          all_attributes = Humpyard::Element.column_names
          ignored_attributes = ['id', 'created_at', 'updated_at', 'content_data_id', 'content_data_type']
          attributes_to_delegate = all_attributes - ignored_attributes
          attributes_to_delegate.each do |attrib|
            base.delegate "#{attrib}", "#{attrib}=", "#{attrib}?", :to => :element
            if attrib.match /_id$/
              attrib = attrib.gsub /(_id)$/, ''
              base.delegate "#{attrib}", "#{attrib}=", "#{attrib}?", :to => :element
            end
          end
          
          base.extend ClassMethods

        end

        def element_with_autobuild
          element_without_autobuild || build_element
        end
        
        def column_for_attribute_with_element_column_for_attribute(attr)
          ret = column_for_attribute_without_element_column_for_attribute(attr) || element.column_for_attribute(attr)
        end
        
#        def method_missing(meth, *args, &blk)
#          element.send(meth, *args, &blk)
#        rescue NoMethodError
#          super
#        end

        module ClassMethods
          
        end

        module InstanceMethods

        end
        
      protected
        def element_must_be_valid
          unless element.valid?
            element.errors.each do |attr, message|
              errors.add(attr, message)
            end
          end
        end
      end
    end
  end
end

class ActiveRecord::Base
  def self.acts_as_humpyard_element(options = {})
    set_table_name "#{Humpyard::config.table_name_prefix}elements_#{name.split('::').last.underscore.pluralize}"
    include Humpyard::ActiveRecord::Acts::Element
  end
end