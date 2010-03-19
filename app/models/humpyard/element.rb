module Humpyard
  ####
  # Humpyard::Element is a model of an element to display on a Humpyard::Page.
  class Element < ActiveRecord::Base
    set_table_name "#{Humpyard::config.table_name_prefix}elements"
    
    belongs_to :page
  end
end