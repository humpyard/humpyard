module Humpyard
  class Page < ActiveRecord::Base
    set_table_name "#{Humpyard::config.table_name_prefix}pages"
    
    has_many :elements
  end
end