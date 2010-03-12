module Humpyard
  class Element < ActiveRecord::Base
    set_table_name "#{Humpyard::config.table_name_prefix}elements"
    
    belongs_to :page
  end
end