module Humpyard
  ####
  # Humpyard::Page is the model for your pages. It holds the 
  # Humpyard::Elements containing the content of your page
  # and some meta data for the page itself.
  class Page < ActiveRecord::Base
    set_table_name "#{Humpyard::config.table_name_prefix}pages"
    
    require 'acts_as_tree'
    
    acts_as_tree :order => :position
    
    has_many :elements
    
    # Return the human readable URL for the page
    #
    # 
    def human_url(prefix_params={})
      prefix_params[:locale] ||= I18n.locale
      
      if self.name == 'index'
        "/#{Humpyard::config.parsed_www_prefix(prefix_params).gsub(/[^\/]*$/, '')}"
      else
        prefix_params[:locale] ||= I18n.locale 
        "/#{Humpyard::config.parsed_www_prefix(prefix_params)}#{(self.ancestors.reverse + [self]).collect{|p| p.name} * '/'}.html"
      end
    end
  end
end