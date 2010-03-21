module Humpyard
  ####
  # Humpyard::Element is a model of an element to display on a Humpyard::Page.
  class Element < ::ActiveRecord::Base
    set_table_name "#{Humpyard::config.table_name_prefix}elements"

    belongs_to :page, :class_name => 'Humpyard::Page'
    belongs_to :content_data, :polymorphic => true
    
    # Return the logical modification time for the element.
    #
    def last_modified
      rails_root_mtime = Time.zone.at(::File.new("#{Rails.root}").mtime)
      timestamps = [rails_root_mtime, self.updated_at]
      timestamps.sort.last
    end
    
  end
end