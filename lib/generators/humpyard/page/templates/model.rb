class <%= class_name %> < ActiveRecord::Base
  acts_as_humpyard_page
  
  <% if attributes.size > 0 -%>
attr_accessible <%= attributes.map{|attribute| attribute.reference? ? ":#{attribute.name}, :#{attribute.name}_id" : ":#{attribute.name}"} * ', ' %>
  <% end -%> 
  <% attributes.select {|attr| attr.reference? }.each do |attribute| -%>
belongs_to :<%= attribute.name %>
  <% end -%>
  
  def parse_path(path)
    # return nil if path.size != 1
    #
    # item = items.find_by_title_for_url(path[0])
    # return nil if item.nil?
    #
    # return {
    #   :partial => 'detail',
    #   :locals => {:item => item}
    # }
  end
  
  def child_pages
    []
  end
  
  def site_map(locale)
    {
      :url => page.human_url(:locale => locale),
      :lastmod => page.last_modified,
      :children => []  # ToDo: return list of dynamic content pages  
    }
  end
end