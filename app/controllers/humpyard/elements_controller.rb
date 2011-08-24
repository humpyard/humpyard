module Humpyard
  ####
  # Humpyard::ElementController is the controller for editing your elements
  class ElementsController < ::ApplicationController
    
    rescue_from ::CanCan::AccessDenied do |exception|
      render json: {
        status: :failed
      }, status: 403
      return
    end
    
    rescue_from ::ActiveRecord::RecordNotFound, ::ActionController::RoutingError do |exception|
      render json: {
        status: :failed
      }, status: 404
      return
    end
    
    # Dialog content for a new element
    def new
      raise ::ActionController::RoutingError, 'Element type not found' if Humpyard::config.element_types[params[:type]].blank?
      
      @element = Humpyard::config.element_types[params[:type]].new(
        page_id: params[:page_id], 
        container_id: params[:container_id].to_i > 0 ? params[:container_id].to_i : nil,
        page_yield_name: params[:yield_name].blank? ? 'main' : params[:yield_name],
        shared_state: 0)
      
      authorize! :create, @element.element 
      
      @element_type = params[:type]
      @prev = Humpyard::Element.find_by_id(params[:prev_id])
      @next = Humpyard::Element.find_by_id(params[:next_id])
      
      render partial: 'edit'
    end
    
    # Create a new element
    def create
      raise ::ActionController::RoutingError, 'Element type not found' if Humpyard::config.element_types[params[:type]].blank?
      
      @element = Humpyard::config.element_types[params[:type]].new params[:element]
            
      authorize! :create, @element.element
            
      if @element.save
        @prev = Humpyard::Element.find_by_id(params[:prev_id])
        @next = Humpyard::Element.find_by_id(params[:next_id])
        
        do_move(@element, @prev, @next)
      
        insert_options = {
          element: "hy-id-#{@element.element.id}",
          url: humpyard_element_path(@element.element),
          parent: @element.container ? "hy-id-#{@element.container.id}" : "hy-content-#{@element.page_yield_name}"
        }
        
        insert_options[:before] = "hy-id-#{@next.id}" if @next
        insert_options[:after] = "hy-id-#{@prev.id}" if not @next and @prev
      
        render json: {
          status: :ok,
          dialog: :close,
          insert: [insert_options]
        }
      else
        render json: {
          status: :failed, 
          errors: @element.errors
        }
      end
    end
    
    # Inline edit content for an existing element
    def inline_edit
      raw_element = Humpyard::Element.find(params[:id])
      
      authorize! :update, raw_element
      
      @element = raw_element.content_data
      
      render partial: 'inline_edit'
    end

    # Dialog content for an existing element
    def edit
      raw_element = Humpyard::Element.find(params[:id])
      
      authorize! :update, raw_element
      
      @element = raw_element.content_data
      
      render partial: 'edit'
    end
    
    # Update an existing element
    def update
      @element = Humpyard::Element.find(params[:id])  
    
      authorize! :update, @element
      
      if @element.content_data.update_attributes params[:element]
        render json: {
          status: :ok,
          dialog: :close,
          replace: [
            { 
              element: "hy-id-#{@element.id}",
              url: humpyard_element_path(@element)
            }
          ]
        }
      else
        render json: {
          status: :failed, 
          errors: @element.content_data.errors
        }
      end
    end

    
    # Move an element
    def move
      @element = Humpyard::Element.find(params[:id])
            
      authorize! :update, @element
      
      @element.update_attributes(
        container: Humpyard::Element.find_by_id(params[:container_id]), 
        page_yield_name: params[:yield_name]
      )
      @prev = Humpyard::Element.find_by_id(params[:prev_id])
      @next = Humpyard::Element.find_by_id(params[:next_id])
      
      do_move(@element, @prev, @next)
      
      render json: {
        status: :ok
      }
    end
    
    # Destroy an element
    def destroy      
      @element = Humpyard::Element.find(params[:id])
      
      authorize! :destroy, @element  
      
      @element.destroy
      
      render json: {
        status: :ok
      }
    end
        
    # Render a given element
    def show
      @element = Humpyard::Element.find(params[:id])
      
      authorize! :show, @element  
      
      render partial: 'show', locals: {element: @element}
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