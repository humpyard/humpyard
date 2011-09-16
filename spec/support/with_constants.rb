def parse(constant)
  source, _, constant_name = constant.to_s.rpartition('::')

  [source.constantize, constant_name]
end

def with_constants(constants, &block)
  saved_constants = {}
  constants.each do |constant, val|
    source_object, const_name = parse(constant)

    begin
      saved_constants[constant] = source_object.const_get(const_name)
    rescue
    end
    
    Kernel::silence_warnings { source_object.const_set(const_name, val) }
  end

  begin
    block.call
  ensure
    constants.each do |constant, val|
      source_object, const_name = parse(constant)

      Kernel::silence_warnings { source_object.const_set(const_name, saved_constants[constant]) }
    end
  end
end