module Humpyard
  ####
  # Humpyard::Element is a model of an element to display on a Humpyard::Page.
  class Element < ::ActiveRecord::Base
    attr_accessible :page, :page_id, :content_data, :content_data_id, :content_data_type, :page_yield_name, :container, :container_id, :display_until, :display_from, :shared_state

    set_table_name "#{Humpyard::config.table_name_prefix}elements"

    belongs_to :page, :class_name => 'Humpyard::Page'
    belongs_to :container, :class_name => 'Humpyard::Element'
    belongs_to :content_data, :polymorphic => true, :dependent => :destroy
    has_many :elements, :class_name => 'Humpyard::Element', :foreign_key => :container_id, :order => :position
    
    delegate :'is_humpyard_container_element?', :'is_humpyard_element?', :to => :content_data

    validates_with Humpyard::ActiveModel::PublishRangeValidator, {:attributes => [:display_from, :display_until]}
    
    after_create :stamp_page_modified_now
    after_update :stamp_page_modified_now
    after_destroy :stamp_page_modified_now
    
    def stamp_page_modified_now
      # Set page's modified_at to now without changing it's last_updated_at column
      Page.update_all ['modified_at = ?', Time.now], ['id = ?', page.id]
      
      # TODO: set other pages' modified_at if element is shared
    end
    
    # Elements can be shared on other pages. this adds #unshared?, #shared_on_siblings?, shared_on_children? getters
    # plus #to_unshared, #to_shared_on_siblings, #to_shared_on_children "setters"
    # 
    SHARED_STATES = { 
      :unshared => 0,
      :shared_on_siblings => 1,
      :shared_on_children => 2
    }.each_pair do |key, value|
      define_method "#{key}?" do
        shared_state.to_i == value
      end
      define_method "to_#{key}" do
        update_attribute :shared_state, value.to_i unless state == value # no point in troubling the database if the state is already == value
      end
    end


    # Return the logical modification time for the element.
    #
    def last_modified
      rails_root_mtime = Time.zone.at(::File.new("#{Rails.root}").mtime)
      timestamps = [rails_root_mtime, self.updated_at]
      timestamps.sort.last
    end
    

    
  end
end