class <%= class_name %> < ActiveRecord::Base
  acts_as_authentic 
  
  def is_admin?
    self.admin ? true : false
  end
end