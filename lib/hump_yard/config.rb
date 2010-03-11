require "hump_yard"

module HumpYard
  class Config 
    attr_writer :table_name_prefix
    
    def initialize(&block)
      configure(&block) if block_given?
    end

    def configure(&block)
      yield(self)
    end
    
    def table_name_prefix 
      @table_name_prefix ||= 'hump_yard_'
    end
  end
end