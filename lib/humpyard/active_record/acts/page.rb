module Humpyard
  module ActiveRecord
    module Acts
      module Page
        
        def self.included(base)
          base.has_one :page, :as => :content_data, :class_name => 'Humpyard::Page', :autosave => true
          base.validate :page_must_be_valid
          base.alias_method_chain :page, :autobuild 
          base.alias_method_chain :column_for_attribute, :page_column_for_attribute
          
          begin
            all_attributes = Humpyard::Page.column_names + Humpyard::Page.translated_attribute_names.map{|a| a.to_s}
          rescue
            # Table not migrated
            all_attributes = []
          end
          ignored_attributes = ['id', 'created_at', 'updated_at', 'content_data_id', 'content_data_type']
          attributes_to_delegate = all_attributes - ignored_attributes
          attributes_to_delegate.each do |attrib|
            base.delegate "#{attrib}", "#{attrib}=", "#{attrib}?", :to => :page
            if attrib.match /_id$/
              attrib = attrib.gsub /(_id)$/, ''
              base.delegate "#{attrib}", "#{attrib}=", "#{attrib}?", :to => :page
            end
          end
          
          base.extend ClassMethods
        end
        
        def page_with_autobuild
          page_without_autobuild || build_page
        end

        def column_for_attribute_with_page_column_for_attribute(attr)
          ret = column_for_attribute_without_page_column_for_attribute(attr) || page.column_for_attribute(attr) || page.translation_class.new.column_for_attribute(attr)
        end

        def is_humpyard_page?
          self.class.is_humpyard_page?
        end

        def is_humpyard_dynamic_page?
          self.class.is_humpyard_dynamic_page?
        end

        module ClassMethods
          def is_humpyard_page?
            true
          end

          def is_humpyard_dynamic_page?
            true
          end          
        end
        
      protected
        def page_must_be_valid
          unless page.valid?
            page.errors.each do |attr, message|
              errors.add(attr, message)
            end
          end
        end
        
      end
    end
  end
end

class ActiveRecord::Base
  def self.acts_as_humpyard_page(options = {})
    set_table_name "#{Humpyard::config.table_name_prefix}pages_#{name.split('::').last.underscore.pluralize}" if options[:system_page]
    include Humpyard::ActiveRecord::Acts::Page
  end
end