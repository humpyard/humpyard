class <%= class_name %> < ActiveRecord::Base
  acts_as_humpyard_element
  
  <% attributes.select {|attr| attr.reference? }.each do |attribute| -%>
  belongs_to :<%= attribute.name %>
  <% end -%>
  
end