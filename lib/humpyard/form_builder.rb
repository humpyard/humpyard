module Humpyard
  ####
  # Humpyard::FormHelper is a helper for forms in Humpyard 
  class FormBuilder 
    attr_reader :record, :options
    
    def initialize(renderer, record, options={})
      @renderer = renderer
      @record = record
      @options = options
    end
    
    def namespace
      if @options[:as]
        @options[:as]
      else
        @record.class.name.underscore.gsub('/', '_')
      end
    end
    
    def inputs
    end
    
    def input(name, options={})
      @renderer.render :partial => '/humpyard/forms/input', :locals => {:form => self, :name => name, :options => options}
    end
    
    def submit(options={})
      @renderer.render :partial => '/humpyard/forms/submit', :locals => {:form => self, :options => options}
    end
  end
end