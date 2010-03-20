module Humpyard
  module ActiveRecord
    module Acts
      module Element
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          def acts_as_humpyard_element(options = {})
            #configuration = { :foreign_key => "parent_id", :order => nil, :counter_cache => nil }
            #configuration.update(options) if options.is_a?(Hash)

            set_table_name "#{Humpyard::config.table_name_prefix}elements_#{name.split('::').last.underscore.pluralize}"

            has_one :element, :as => :content_data, :class_name => Humpyard::Element
            
            #validates_presence_of :element
          end
        end

        module InstanceMethods
#          after_create do |record|
#            begin
#              record.element = Humpyard::Element.create!(
#                :content_data => record
#              )
#            rescue => e
#              logger.error "Cannot create Humpyard::Element (Cause #{e.to_s})"
#              record.destroy
#            end
#          end
        end
      end
    end
  end
end