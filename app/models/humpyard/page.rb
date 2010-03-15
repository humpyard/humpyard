module Humpyard
  class Page < ActiveRecord::Base
    set_table_name "#{Humpyard::config.table_name_prefix}pages"
    
    require 'acts_as_tree'
    
    acts_as_tree :order => :position
    
    has_many :elements
  end
end