module Humpyard
  ####
  # Humpyard::Element is a model of an element to display on a Humpyard::Page.
  class Element < ::ActiveRecord::Base
    #attr_accessor :page, :page_id, :content_data, :content_data_type
    
    set_table_name "#{Humpyard::config.table_name_prefix}elements"

    belongs_to :page, :class_name => 'Humpyard::Page'
    belongs_to :container, :class_name => 'Humpyard::Element'
    belongs_to :content_data, :polymorphic => true, :dependent => :destroy
    has_many :elements, :class_name => 'Humpyard::Element', :foreign_key => :container_id, :order => :position
    
    delegate :'is_humpyard_container_element?', :'is_humpyard_element?', :to => :content_data

    validates_with Humpyard::PublishRangeValidator, {:attributes => [:display_from, :display_until]}
    
    # Return the logical modification time for the element.
    #
    def last_modified
      rails_root_mtime = Time.zone.at(::File.new("#{Rails.root}").mtime)
      timestamps = [rails_root_mtime, self.updated_at]
      timestamps.sort.last
    end
    
  end
end