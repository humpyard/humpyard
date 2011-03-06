module Humpyard
  ####
  # Humpyard::ElementController is the controller for editing your elements
  class ElementsController < ::ApplicationController
    
    # Dialog content for a new element
    def new
      @element = Humpyard::config.element_types[params[:type]].new(
        :page_id => params[:page_id], 
        :container_id => params[:container_id].to_i > 0 ? params[:container_id].to_i : nil,
        :page_yield_name => params[:yield_name].blank? ? 'main' : params[:yield_name],
        :shared_state => 0)
      
      authorize! :create, @element.element 
      
      @element_type = params[:type]
      @prev = Humpyard::Element.find_by_id(params[:prev_id])
      @next = Humpyard::Element.find_by_id(params[:next_id])
      
      render :partial => 'edit'
    end
    
    # Create a new element
    def create
      @element = Humpyard::config.element_types[params[:type]].new params[:element]
            
      unless can? :create, @element.element
        render :json => {
          :status => :failed
        }, :status => 403
        return
      end      
            
      if @element.save
        @prev = Humpyard::Element.find_by_id(params[:prev_id])
        @next = Humpyard::Element.find_by_id(params[:next_id])
        
        do_move(@element, @prev, @next)
      
        insert_options = {
          :element => "hy-id-#{@element.element.id}",
          :url => humpyard_element_path(@element.element),
          :parent => @element.container ? "hy-id-#{@element.container.id}" : "hy-content-#{@element.page_yield_name}"
        }
        
        insert_options[:before] = "hy-id-#{@next.id}" if @next
        insert_options[:after] = "hy-id-#{@prev.id}" if not @next and @prev
      
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
      @element = Humpyard::Element.find(params[:id]).content_data
      
      authorize! :update, @element.element
      
      render :partial => 'inline_edit'
    end

    # Dialog content for an existing element
    def edit
      @element = Humpyard::Element.find(params[:id]).content_data
      
      authorize! :update, @element.element
      
      render :partial => 'edit'
    end
    
    # Update an existing element
    def update
      @element = Humpyard::Element.find(params[:id])
      if @element
        unless can? :update, @element
          render :json => {
            :status => :failed
          }, :status => 403
          return
        end
        
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
        unless can? :update, @element
          render :json => {
            :status => :failed
          }, :status => 403
          return
        end
        
        @element.update_attributes(
          :container => Humpyard::Element.find_by_id(params[:container_id]), 
          :page_yield_name => params[:yield_name]
        )
        @prev = Humpyard::Element.find_by_id(params[:prev_id])
        @next = Humpyard::Element.find_by_id(params[:next_id])
        
        do_move(@element, @prev, @next)
        
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
      @element = Humpyard::Element.find_by_id(params[:id])
      
      if can? :destroy, @element  
        @element.destroy
      else
        @error = "You have no permission to delete this element (id: #{@element.class}:#{params[:id]})"
        render :error
      end
    end
        
    # Render a given element
    def show
      @element = Humpyard::Element.find(params[:id])
      
      authorize! :read, @element  
      
      render :partial => 'show', :locals => {:element => @element}
    end
    
    private
    def do_move(element, prev_element, next_element) #:nodoc#
      if element.container
        neighbours = element.container.elements
      else
        neighbours = element.page.root_elements(element.page_yield_name)
      end
      
      #p "before #{next_id} and after #{prev_id}"
      p "page_yield: #{element.page_yield_name}"

      position = 0
      neighbours.each do |el|    
        if next_element == el
          p "insert element #{element.id} before #{el.id}"
          element.update_attribute :position, position
          position += 1
        end  
        if element != el
          p "process #{el.id} to position #{position}"
          el.update_attribute :position, position unless element.position == position 
        end
        if not next_element and prev_element == el
          p "insert element #{element.id} after #{el.id}"
          position += 1
          element.update_attribute :position, position
        end
        if element != el
          position += 1
        end
      end
    end  
  end
end