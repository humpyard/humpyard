class Create<%= plural_class_name.gsub('::', '') %> < ActiveRecord::Migration
  def self.up
    create_table :<%= plural_name.gsub('/','_') %> do |t|
    <%- for attribute in attributes -%>
      t.<%= attribute.type %> :<%= attribute.name %>
    <%- end -%>
    <%- unless options[:skip_timestamps] -%>
      t.timestamps
    <%- end -%>
    end
  end
  
  def self.down
    drop_table :<%= plural_name.gsub('/','_') %>
  end
end