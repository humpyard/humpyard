module Humpyard
  ####
  # Humpyard::PagesController is the controller for editing and viewing pages
  class PagesController < ::ApplicationController 
    helper 'humpyard::pages'
    
    # Probably unneccassary - may be removed later
    def index
      @root_page = Humpyard::Page.root
      @page = Humpyard::Page.where("id = ?", params[:actual_id]).first
      unless @page.nil?
        @page = @page.content_data
      end
      render :partial => 'index'
    end

    # Dialog content for a new page
    def new
      @page = Humpyard::config.page_types[params[:type]].new
      @page_type = params[:type]
      @prev = Humpyard::Page.where('id = ?', params[:prev_id]).first
      @next = Humpyard::Page.where('id = ?', params[:next_id]).first
      
      render :partial => 'edit'
    end
    
    # Create a new page
    def create
      @page = Humpyard::config.page_types[params[:type]].new params[:page]
      @page.title_for_url = @page.page.suggested_title_for_url
      
      if @page.save
        @prev = Humpyard::Page.where('id = ?', params[:prev_id]).first
        @next = Humpyard::Page.where('id = ?', params[:next_id]).first
        
        #do_move(@page, @prev, @next)
      
        insert_options = {
          :element => "hy-id-#{@page.id}",
          :url => @page,
          :parent => @page.parent ? "hy-page-dialog-item-#{@page.id}" : "hy-page-dialog-pages"
        }
        
        insert_options[:before] = "hy-page-dialog-item-#{@next.id}" if @next
        insert_options[:after] = "hy-page-dialog-item-#{@prev.id}" if not @next and @prev
      
        render :json => {
          :status => :ok,
          :dialog => :close,
          :insert => [insert_options]
        }
      else
        render :json => {
          :status => :failed, 
          :errors => @page.errors
        }
      end
    end
    
    # Dialog content for an existing page
    def edit
      @page = Humpyard::Page.find(params[:id]).content_data
      render :partial => 'edit'
    end
    
    # Update an existing page
    def update
      @page = Humpyard::Page.find(params[:id]).content_data
      if @page
        if @page.update_attributes params[:page]
          @page.title_for_url = @page.page.suggested_title_for_url
          @page.save
          render :json => {
            :status => :ok,
#            :dialog => :close,
            :replace => [
              { 
                :element => "hy-page-dialog-item-#{@page.id}",
                :content => @page.title
              }
            ]
          }
        else
          render :json => {
            :status => :failed, 
            :errors => @page.errors
          }
        end
      else
        render :json => {
          :status => :failed
        }, :status => 404
      end
      
    end
    
    # Move a page
    def move
      @page = Humpyard::Page.find(params[:id])
      
      if @page
        parent = Humpyard::Page.where('id = ?', params[:parent_id]).first
        unless parent
          parent = Humpyard::Page.root_page
        end
        @page.update_attribute :parent, parent
        @prev = Humpyard::Page.where('id = ?', params[:prev_id]).first
        @next = Humpyard::Page.where('id = ?', params[:next_id]).first
        
        do_move(@page, @prev, @next)
        
        render :json => {
          :status => :ok
        }
      else
        render :json => {
          :status => :failed
        }, :status => 404        
      end
    end
    
    # Destroy a page
    def destroy
      @page = Humpyard::Page.find(params[:id])
      @page.destroy
    end

    
    # Render a given page
    # 
    # When a "webpath" parameter is given it will render the page with that name.
    # This is what happens when you call a page with it's pretty URL.
    #
    # When no "name" is given and an "id" parameter is given it will render the
    # page with the given id.
    #
    # When no "name" nor "id" parameter is given it will render the root page.
    def show
      # No page found at the beginning
      @page = nil

      if params[:locale] and Humpyard.config.locales.include? params[:locale].to_sym
        I18n.locale = params[:locale]
      end
      
      # Find page by name
      if not params[:webpath].blank?
        dyn_page_path = false
        parent_page = nil
        params[:webpath].split('/').each do |path_part|
          # Ignore multiple slashes in URLs
          unless(path_part.blank?)
            if(dyn_page_path) 
              dyn_page_path << path_part
            else     
              # Find page by name and parent; parent=nil means page on root level
              @page = Page.find_by_title_for_url CGI::escape(path_part), :locale => I18n.locale
              # Raise 404 if no page was found for the URL or subpart
              raise ::ActionController::RoutingError, "No route matches \"#{request.path}\" (X4201)" if @page.nil?
              raise ::ActionController::RoutingError, "No route matches \"#{request.path}\" (X4202)" if @page.parent != parent_page
              
              parent_page = @page unless @page.is_root_page?
              dyn_page_path = [] if @page.content_data.is_humpyard_dynamic_page? 
            end
          end
        end

        if @page.content_data.is_humpyard_dynamic_page? and dyn_page_path.size > 0
          @sub_page = @page.parse_path(dyn_page_path)
          
          # Raise 404 if no page was found for the sub_page part
          raise ::ActionController::RoutingError, "No route matches \"#{request.path}\" (D4201)" if @sub_page.blank?

          @page_partial = "/humpyard/pages/#{@page.content_data_type.split('::').last.underscore.pluralize}/#{@sub_page[:partial]}" if @sub_page[:partial]
          @local_vars = {:page => @page}.merge(@sub_page[:locals]) if @sub_page[:locals] and @sub_page[:locals].class == Hash
        end
        
      # Find page by id
      elsif not params[:id].blank?
        # Render page by id if not webpath was given but an id
        @page = Page.find(params[:id])
      # Find root page
      else
        # Render index page if neither id or webpath was given
        @page = Page.root_page
        unless @page
          render '/humpyard/pages/welcome'
          return false
        end
      end
      
      # Raise 404 if no page was found
      raise ::ActionController::RoutingError, "No route matches \"#{request.path}\"" if @page.nil?
      
      @page_partial ||= "/humpyard/pages/#{@page.content_data_type.split('::').last.underscore.pluralize}/show"
      @local_vars ||= {:page => @page}
      
      response.headers['X-Humpyard-Page'] = "#{@page.id}"
      render :layout => @page.template_name
    end
    
    # Render the sitemap.xml for robots
    def sitemap
      require 'builder'
      
      xml = ::Builder::XmlMarkup.new :indent => 2
      xml.instruct!
      xml.tag! :urlset, {
        'xmlns'=>"http://www.sitemaps.org/schemas/sitemap/0.9",
        'xmlns:xsi'=>"http://www.w3.org/2001/XMLSchema-instance",
        'xsi:schemaLocation'=>"http://www.sitemaps.org/schemas/sitemap/0.9\nhttp://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd"
      } do

        base_url = "#{request.protocol}#{request.host}#{request.port==80 ? '' : ":#{request.port}"}"

        if Page.root_page
          Humpyard.config.locales.each do |locale|
            add_to_sitemap xml, base_url, locale, [Page.root_page.content_data.site_map(locale)]
          end
        end
      end
      render :xml => xml.target!
    end

    private
    def add_to_sitemap xml, base_url, locale, pages, priority=0.8, changefreq='daily' 
      pages.each do |page|
        xml.tag! :url do
          xml.tag! :loc, "#{base_url}#{page[:url]}"
          xml.tag! :lastmod, page[:lastmod].nil? ? nil : page[:lastmod].to_time.strftime("%FT%T%z").gsub(/00$/,':00')
          xml.tag! :changefreq, changefreq
          xml.tag! :priority, page[:index] ? 1.0 : priority
        end
      
        add_to_sitemap xml, base_url, locale, page[:children], priority/2
      end
    end
    
    def do_move(page, prev_page, next_page) #:nodoc#
      if page.parent
        neighbours = page.parent.child_pages
      else
        neighbours = Humpyard::Page.root_page.child_pages
      end

      #p "before #{next_id} and after #{prev_id}"

      position = 0
      neighbours.each do |p|    
        if next_page == p
          puts "insert page #{page.id} before #{p.id}"
          page.update_attribute :position, position
          position += 1
        end  
        if page != p
          puts "process page #{p.id} to position #{position}"
          p.update_attribute :position, position 
        end
        if not next_page and prev_page == p
          puts "insert page #{page.id} after #{p.id}"
          position += 1
          page.update_attribute :position, position
        end
        if page != p
          position += 1
        end
      end
    end  
  end
end