module Humpyard
  class Page < ActiveRecord::Base
    set_table_name "#{Humpyard::config.table_name_prefix}pages"
    
    require 'acts_as_tree'
    
    acts_as_tree :order => :position
    
    has_many :elements
    
    def human_url(prefix_params={})
      
      if self.name == 'index'
        '/'
      else
        prefix_params[:locale] ||= I18n.locale 
        "/#{Humpyard::config.parsed_www_prefix(prefix_params)}#{(self.ancestors.reverse + [self]).collect{|p| p.name} * '/'}.html"
      end
    end
  end
end