module Humpyard
  ####
  # Humpyard::PagesController is the controller for editing and viewing pages
  class PagesController < ::ApplicationController 
    helper 'humpyard::pages'
    
    rescue_from ::CanCan::AccessDenied do |exception|
      render json: {
        status: :failed
      }, status: 403
      return
    end
    
    rescue_from ::ActiveRecord::RecordNotFound, ::ActionController::RoutingError do |exception|
      respond_to do |format|
        format.json do
          render json: {
            status: :failed
          }, status: 404
        end
        format.html {
          @page = ::Humpyard::Page.new()
          render '/humpyard/pages/not_found', status: 404
        }
      end
      return
    end
    
    # Probably unneccassary - may be removed later
    def index
      authorize! :manage, Humpyard::Page  
      
      @root_page = Humpyard::Page.root
      @page = Humpyard::Page.find_by_id(params[:actual_page_id])
     
      unless @page.nil?
        @page = @page.content_data
      end
      render partial: 'index'
    end

    # Dialog content for a new page
    def new
      raise ::ActionController::RoutingError, 'Page type not found' if Humpyard::config.page_types[params[:type]].blank?
      
      @page = Humpyard::config.page_types[params[:type]].new
      
      authorize! :create, @page.page
      
      @page_type = params[:type]
      @prev = Humpyard::Page.find_by_id(params[:prev_id])
      @next = Humpyard::Page.find_by_id(params[:next_id])
      
      render partial: 'edit'
    end
    
    # Create a new page
    def create    
      raise ::ActionController::RoutingError, 'Page type not found' if Humpyard::config.page_types[params[:type]].blank?
      
      @page = Humpyard::config.page_types[params[:type]].new params[:page]
      @page.title_for_url = @page.page.suggested_title_for_url
      
      authorize! :create, @page.page
      
      if @page.save
        @prev = Humpyard::Page.find_by_id(params[:prev_id])
        @next = Humpyard::Page.find_by_id(params[:next_id])
      
        replace_options = {
          element: "hy-page-treeview",
          content: render_to_string(partial: "tree.html", locals: {page: @page})
        }
      
        render json: {
          status: :ok,
          replace: [replace_options],
          flash: {
            level: 'info',
            content: I18n.t('humpyard_form.flashes.create_success', model: Humpyard::Page.model_name.human)
          }
        }
      else
        render json: {
          status: :failed, 
          errors: @page.errors,
          flash: {
            level: 'error',
            content: I18n.t('humpyard_form.flashes.create_fail', model: Humpyard::Page.model_name.human)
          }
        }
      end
    end
    
    # Dialog content for an existing page
    def edit
      raw_page = Humpyard::Page.find(params[:id])

      authorize! :update, raw_page
      @page = raw_page.content_data    
      render partial: 'edit'
    end
    
    # Update an existing page
    def update
      raw_page = Humpyard::Page.find(params[:id])
      
      authorize! :update, raw_page
      
      @page = raw_page.content_data
      
      if @page.update_attributes params[:page]
        @page.title_for_url = raw_page.suggested_title_for_url
        @page.save
        render json: {
          status: :ok,
          replace: [
            { 
              element: "hy-page-treeview-text-#{@page.id}",
              content: @page.title
            }
          ],
          flash: {
            level: 'info',
            content: I18n.t('humpyard_form.flashes.update_success', model: Humpyard::Page.model_name.human)
          }
        }
      else
        render json: {
          status: :failed, 
          errors: @page.errors,
          flash: {
            level: 'error',
            content: I18n.t('humpyard_form.flashes.update_fail', model: Humpyard::Page.model_name.human)
          }
        }
      end
    end
    
    # Move a page
    def move
      @page = Humpyard::Page.find(params[:id])
      
      authorize! :update, @page
      
      parent = Humpyard::Page.find_by_id(params[:parent_id])
      # by default, make it possible to move page to root, uncomment to do otherwise:
      #unless parent
      #  parent = Humpyard::Page.root_page
      #end
      @page.update_attribute :parent, parent
      @prev = Humpyard::Page.find_by_id(params[:prev_id])
      @next = Humpyard::Page.find_by_id(params[:next_id])
      
      do_move(@page, @prev, @next)
      
      replace_options = {
        element: "hy-page-treeview",
        content: render_to_string(partial: "tree.html", locals: {page: @page})
      }
      
      render json: {
        status: :ok,
        replace: [replace_options]
      }
    end
    
    # Destroy a page
    def destroy
      @page = Humpyard::Page.find(params[:id])
      
      authorize! :destroy, @page  
      
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
      elsif session[:humpyard_locale]
        I18n.locale = session[:humpyard_locale]
      else
        I18n.locale = Humpyard.config.locales.first
      end
      
      # Find page by name
      if params[:webpath] == 'index' or params[:webpath].blank?
        @page = Page.root_page force_reload: true
        unless @page
          @page = Page.new
          render '/humpyard/pages/welcome'
          return false
        end
      else     
        dyn_page_path = false
        parent_page = nil
        params[:webpath].split('/').each do |path_part|
          # Ignore multiple slashes in URLs
          unless(path_part.blank?)
            if(dyn_page_path) 
              dyn_page_path << path_part
            else     
              # Find page by name and parent; parent=nil means page on root level
              @page = Page.with_translated_attribute(:title_for_url, CGI::escape(path_part), I18n.locale).first
              # Raise 404 if no page was found for the URL or subpart
              raise ::ActionController::RoutingError, "No route matches \"#{request.path}\" (X4201) [#{path_part}]" if @page.nil?
              raise ::ActionController::RoutingError, "No route matches \"#{request.path}\" (X4202)" if not (@page.parent == parent_page or @page.parent == Humpyard::Page.root_page)
            
              parent_page = @page unless @page.is_root_page?
              dyn_page_path = [] if @page.content_data.try(:is_humpyard_dynamic_page?)
            end
          end
        end

        if @page.content_data.try(:is_humpyard_dynamic_page?) and dyn_page_path.size > 0
          @sub_page = @page.content_data.parse_path(dyn_page_path)
        
          # Raise 404 if no page was found for the sub_page part
          raise ::ActionController::RoutingError, "No route matches \"#{request.path}\" (D4201)" if @sub_page.blank?

          @page_partial = "/humpyard/pages/#{@page.content_data_type.split('::').last.underscore.pluralize}/#{@sub_page[:partial]}" if @sub_page[:partial]
          @local_vars = {page: @page}.merge(@sub_page[:locals]) if @sub_page[:locals] and @sub_page[:locals].class == Hash
        
          # render partial only if request was an AJAX-call
          if request.xhr?
            respond_to do |format|
              format.html {
                render partial: @page_partial, locals: @local_vars
              }
            end
            return
          end
        end
      end
      
      # Raise 404 if no page was found
      raise ::ActionController::RoutingError, "No route matches \"#{request.path}\"" if @page.nil? or @page.content_data.try(:is_humpyard_virtual_page?)
      
      response.headers['X-Humpyard-Page'] = "#{@page.id}"
      response.headers['X-Humpyard-Modified'] = "#{@page.last_modified}"
      response.headers['X-Humpyard-ServerTime'] = "#{Time.now.utc}"
 
      @page_partial ||= "/humpyard/pages/#{@page.content_data_type.split('::').last.underscore.pluralize}/show"
      @local_vars ||= {page: @page}

      self.class.layout(@page.template_name)

      if Rails.application.config.action_controller.perform_caching and not @page.always_refresh
        fresh_when etag: "#{humpyard_user.nil? ? '' : humpyard_user}p#{@page.id}m#{@page.last_modified}", last_modified: @page.last_modified(include_pages: true), public: @humpyard_user.nil?
      end
    end
    
    # Render the sitemap.xml for robots
    def sitemap
      require 'builder'
      
      xml = ::Builder::XmlMarkup.new indent: 2
      xml.instruct!
      xml.tag! :urlset, {
        'xmlns'=>"http://www.sitemaps.org/schemas/sitemap/0.9",
        'xmlns:xsi'=>"http://www.w3.org/2001/XMLSchema-instance",
        'xsi:schemaLocation'=>"http://www.sitemaps.org/schemas/sitemap/0.9\nhttp://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd"
      } do

        if root_page = Page.root_page
          Humpyard.config.locales.each do |locale|
            add_to_sitemap xml, base_url, locale, [{
                index: true,
                url: root_page.human_url(locale: locale),
                lastmod: root_page.last_modified,
                children: []
              }] + root_page.child_pages(single_root: true).map{|p| p.content_data.site_map(locale)}
          end
        end
      end
      render xml: xml.target!
    end
    
    def robots
      robot_rules = "User-agent: *\n"

      not_searchable = Page.where('searchable = ?', false)
      if not_searchable.size > 0
        not_searchable.each do |page|
          Humpyard.config.locales.each do |locale|
            url = page.human_url(locale: locale)
            robot_rules += "Disallow: #{url}\n"
            robot_rules += "Disallow: #{url.gsub(/.html$/, '/')}\n"
          end
        end
      else
        robot_rules += "Disallow:\n"
      end
      
      robot_rules += "Sitemap: #{base_url}/sitemap.xml"
      
      render text: robot_rules, content_type: 'text/plain; charset=utf-8\n'
    end

    private
    def add_to_sitemap xml, base_url, locale, pages, priority=0.8, changefreq='daily' 
      pages.each do |page|
        if page
          unless page[:hidden]
            xml.tag! :url do
              xml.tag! :loc, "#{base_url}#{page[:url]}"
              xml.tag! :lastmod, page[:lastmod].nil? ? nil : page[:lastmod].to_time.strftime("%FT%T%z").gsub(/00$/,':00')
              xml.tag! :changefreq, page[:changefreq] ? page[:changefreq] : changefreq
              xml.tag! :priority, page[:index] ? 1.0 : priority
            end
          end
          add_to_sitemap xml, base_url, locale, page[:children], priority/2
        end
      end
    end
    
    def base_url 
      "#{request.protocol}#{request.host}#{request.port==80 ? '' : ":#{request.port}"}"
    end
    
    def do_move(page, prev_page, next_page) #:nodoc#
      if page.parent
        neighbours = page.parent.child_pages
      else
        neighbours = Humpyard::Page.where('parent_id IS NULL')
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