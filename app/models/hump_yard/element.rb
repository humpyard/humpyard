module HumpYard
  class Element < ActiveRecord::Base
    @@table_name_prefix = HumpYard::config.table_name_prefix
    
    belongs_to :page
  end
end