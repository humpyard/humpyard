module Humpyard
  module ActiveRecord
    module Acts
      module Asset
        
        def self.included(base)
          base.has_one :asset, as: :content_data, class_name: 'Humpyard::Asset', autosave: true
          base.validate :asset_must_be_valid
          
          begin
            all_attributes = Humpyard::Asset.column_names.map{|a| a.to_s}
          rescue
            # Table not migrated
            all_attributes = []
          end
          ignored_attributes = ['id', 'created_at', 'updated_at', 'content_data_id', 'content_data_type']
          attributes_to_delegate = all_attributes - ignored_attributes
          attributes_to_delegate.each do |attrib|
            base.delegate "#{attrib}", "#{attrib}=", "#{attrib}?", to: :asset
            if attrib.match /_id$/
              attrib = attrib.gsub /(_id)$/, ''
              base.delegate "#{attrib}", "#{attrib}=", "#{attrib}?", to: :asset
            end
          end
          
          Humpyard::Asset.attr_accessible.each do |attr|
            base.attr_accessible attr
          end
          
          base.extend ClassMethods
          
          base.alias_method_chain :asset, :autobuild 
          base.alias_method_chain :column_for_attribute, :asset_column_for_attribute
          
        end
        
        def asset_with_autobuild
          asset_without_autobuild || build_asset
        end

        def column_for_attribute_with_asset_column_for_attribute(attr)
          ret = column_for_attribute_without_asset_column_for_attribute(attr) || Humpyard::Asset.new.column_for_attribute(attr)       
        end

        module ClassMethods
 
        end
        
      protected
        def asset_must_be_valid
          unless asset.valid?
            asset.errors.each do |attr, message|
              errors.add(attr, message)
            end
          end
        end
        
      end
    end
  end
end

class ActiveRecord::Base
  def self.acts_as_humpyard_asset(options = {})
    set_table_name "#{Humpyard::config.table_name_prefix}assets_#{name.split('::').last.underscore.pluralize}" if options[:system_asset]
    include Humpyard::ActiveRecord::Acts::Asset
  end
end