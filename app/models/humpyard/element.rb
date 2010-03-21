module Humpyard
  ####
  # Humpyard::Element is a model of an element to display on a Humpyard::Page.
  class Element < ::ActiveRecord::Base
    #attr_accessor :page, :page_id, :content_data, :content_data_type
    
    set_table_name "#{Humpyard::config.table_name_prefix}elements"

    belongs_to :page, :class_name => 'Humpyard::Page'
    belongs_to :container, :class_name => 'Humpyard::Elements::ContainerElement'
    belongs_to :content_data, :polymorphic => true, :dependent => :destroy
  end
end