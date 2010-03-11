module HumpYard
  class Page < ActiveRecord::Base
    @@table_name_prefix = HumpYard::config.table_name_prefix
    
    has_many :elements
  end
end