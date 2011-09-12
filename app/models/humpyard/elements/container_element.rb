module Humpyard
  class PropertiesModel
    extend ::ActiveModel::Naming
    include ::ActiveModel::Validations    
    
    def initialize fields, json_data=nil
      @fields = fields
      self.from_json(json_data) unless json_data.nil?
    end
    
    def from_json json
      @data = JSON.parse(json)
    end
    
    def to_json
      data.to_json
    end   
       
    def has_field? field
      Rails.logger.debug("Does #{fields} include #{field}")
      fields.include? field.to_sym
    end
    
    def method_missing method, *args, &block
      write = false    
      method_name = method.to_s
      
      if method_name.last == '='
        method_name = method_name[0..-2]
        write = true
      end
      
      if has_field? method_name
        if write
          write_attribute method_name, args.first
        else
          read_attribute method_name
        end
      else
        super
      end
    end
    
    def respond_to? method
      method_name = method.to_s
      
      if method_name.last == '='
        method_name = method_name[0..-2]
      end
      
      if has_field? method_name
        true
      else
        super
      end
    end
    
    #private
    def data
      @data ||= {}
    end
    
    def fields
      @fields ||= {}
    end
    
    def read_attribute(field_name)
      puts "read #{field_name}"
      if has_field? field_name
        data[field_name.to_s]
      else
        raise "No such attribute: #{field_name}"
      end
    end
    
    def write_attribute(field_name, value)
      puts "write #{field_name} with #{value}"
      if has_field? field_name
        data
        @data[field_name.to_s] = value
      else
        raise "No such attribute: #{field_name}"
      end
    end
  end
  
  
  module Elements 
    ####
    # Humpyard::Elements::ContainerElement is a model of a container element.    
    class ContainerElement < ::ActiveRecord::Base
      acts_as_humpyard_container_element system_element: true
      
      attr_accessible :additional_fields, :preset
      validates :preset, presence: true
      
      require 'globalize'
      
      translates :additional_fields_json
      
      def additional_fields=(fields)
        self.additional_fields_json = fields.to_json
      end
      
      def additional_fields
        PropertiesModel.new [:title, :subtitle], additional_fields_json
      end
      
    end
  end
end