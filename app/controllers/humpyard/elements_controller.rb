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
      if @element
        if @element.content_data.update_attributes params[:element]
          render :json => {
            :status => :ok,
            :dialog => :close,
            :replace => [
              { 
                :element => "hy-id-#{@element.id}",
                :url => humpyard_element_path(@element)
              }
            ]
          }
        else
          render :json => {
            :status => :failed, 
            :errors => @element.content_data.errors
          }
        end
      else
        render :json => {
          :status => :failed
        }, :status => 404
      end
    end
        
    # Render a given element
    def show
      @element = Humpyard::Element.find(params[:id])
      render :partial => 'show', :locals => {:element => @element}
    end
  end
end