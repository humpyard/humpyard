class <%= class_name %> < ActiveRecord::Base
  acts_as_humpyard_element
  
  <% if attributes.size > 0 -%>
attr_accessible <%= attributes.map{|attribute| attribute.reference? ? ":#{attribute.name}, :#{attribute.name}_id" : ":#{attribute.name}"} * ', ' %>
  <% end -%> 
  <% attributes.select {|attr| attr.reference? }.each do |attribute| -%>
belongs_to :<%= attribute.name %>
  <% end -%>
  
end