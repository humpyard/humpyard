module Humpyard
  ####
  # Humpyard::ElementController is the controller for editing your elements
  class ElementsController < ::ApplicationController         
    # Dialog content for a new element
    def new
      @element = Humpyard::config.elements[params[:type]].new(:page_id => params[:page_id], :container_id => params[:container_id])
      @element_type = params[:type]
      @prev = Humpyard::Element.where('id = ?', params[:prev_id]).first
      @next = Humpyard::Element.where('id = ?', params[:next_id]).first
      
      render :partial => 'edit'
    end
    
    # Create a new element
    def create
      @element = Humpyard::config.elements[params[:type]].create params[:element]
      if @element
        render :json => {
          :status => :ok,
          :dialog => :close,
          :insert => [
            { 
              :element => "hy-id-#{@element.element.id}",
              :url => humpyard_element_path(@element.element)
            }
          ]
        }
      else
        render :json => {
          :status => :failed, 
          :errors => @element.errors
        }
      end
    end
    
    # Inline edit content for an existing element
    def inline_edit
      render :partial => 'inline_edit'
    end

    # Dialog content for an existing element
    def edit
      @element = Humpyard::Element.find(params[:id]).content_data
      
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
    
    # Destroy an element
    def destroy
      @element = Humpyard::Element.find(params[:id])
      @element.destroy
    end
        
    # Render a given element
    def show
      @element = Humpyard::Element.find(params[:id])
      render :partial => 'show', :locals => {:element => @element}
    end
  end
end