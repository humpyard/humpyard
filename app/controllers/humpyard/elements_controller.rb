module Humpyard
  ####
  # Humpyard::ElementController is the controller for editing your elements
  class ElementsController < ::ApplicationController         
    # Dialog content for a new element
    def new
      render :partial => 'new'
    end
    
    # Create a new element
    def create
      render :partial => 'new'
    end
    
    # Inline edit content for an existing element
    def inline_edit
      render :partial => 'inline_edit'
    end

    # Dialog content for an existing element
    def edit
      @element = Humpyard::Element.find(params[:id])
      
      render :partial => 'edit'
    end
    
    # Update an existing element
    def update
      @element = Humpyard::Element.find(params[:id])
      @element.content_data.update_attributes params[:element]
      render :partial => 'edit'
    end
        
    # Render a given element
    def show
      render :partial => 'show', :locals => {:element => e}
    end
  end
end