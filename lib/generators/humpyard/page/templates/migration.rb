class Create<%= plural_class_name.gsub('::', '')  %> < ActiveRecord::Migration
  def change
    create_table :<%= plural_name.gsub('/', '_') %> do |t|
    <%- for attribute in attributes -%>
      t.<%= attribute.type %> :<%= attribute.name %>
    <%- end -%>
    <%- unless options[:skip_timestamps] -%>
      t.timestamps
    <%- end -%>
    end
  end
end