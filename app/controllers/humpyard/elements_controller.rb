module Humpyard
  ####
  # Humpyard::ElementController is the controller for editing your elements
  class ElementsController < ::ApplicationController         
    # Dialog content for a new element
    def new
      @element = Humpyard::config.elements[params[:type]].new(:page_id => params[:page_id], :container_id => params[:container_id].to_i > 0 ? params[:container_id].to_i : nil)
      @element_type = params[:type]
      @prev = Humpyard::Element.where('id = ?', params[:prev_id]).first
      @next = Humpyard::Element.where('id = ?', params[:next_id]).first
      
      render :partial => 'edit'
    end
    
    # Create a new element
    def create
      @element = Humpyard::config.elements[params[:type]].create params[:element]
            
      if @element
        do_move(@element, params[:prev_id].to_i, params[:next_id].to_i)
      
        insert_options = {
          :element => "hy-id-#{@element.element.id}",
          :url => humpyard_element_path(@element.element),
          :parent => @element.container ? "hy-id-#{@element.container.id}" : "hy-page"
        }
        
        insert_options[:before] = "hy-id-#{params[:next_id]}" if params[:next_id]
        insert_options[:after] = "hy-id-#{params[:prev_id]}" if not params[:next_id] and params[:prev_id]
      
        render :json => {
          :status => :ok,
          :dialog => :close,
          :insert => [insert_options]
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
    
    # Move an element
    def move
      @element = Humpyard::Element.find(params[:id])
      
      if @element
        @element.update_attribute :container, Humpyard::Element.where('id = ?', params[:container_id]).first
        
        do_move(@element, params[:prev_id].to_i, params[:next_id].to_i)
        
        render :json => {
          :status => :ok
        }
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
    
    private
    def do_move(element, prev_id, next_id) #:nodoc#
      if element.container
        neighbours = element.container.elements
      else
        neighbours = element.page.root_elements
      end
      
      #p "before #{next_id} and after #{prev_id}"

      position = 0
      neighbours.each do |el|    
        if next_id == el.id
          #p "insert element #{element.id} before #{el.id}"
          element.update_attribute :position, position
          position += 1
        end  
        if element.id != el.id
          #p "process #{el.id} to position #{position}"
          el.update_attribute :position, position unless element.position == position 
        end
        if not next_id and prev_id == el.id
          #p "insert element #{element.id} after #{el.id}"
          position += 1
          element.update_attribute :position, position
        end
        if element.id != el.id
          position += 1
        end
      end
    end  
  end
end