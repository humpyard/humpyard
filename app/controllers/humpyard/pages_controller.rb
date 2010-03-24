module Humpyard
  ####
  # Humpyard::PagesController is the controller for editing and viewing pages
  class PagesController < ::ApplicationController 
    helper 'humpyard::pages'
    
    before_filter :check_login
    
    # Probably unneccassary - may be removed later
    def index
      
    end

    # Dialog content for a new page
    def new
      
    end
    
    # Create a new page
    def create
      
    end
    
    # Dialog content for an existing page
    def edit
    
    end
    
    # Update an existing page
    def update
      
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
        params[:webpath].split('/').each do |path_part|
          # Ignore multiple slashes in URLs
          unless(path_part.blank?)
            # Find page by name and parent; parent=nil means page on root level
            @page = Page.where(:parent_id=>@page, :name=>path_part).first
            # Raise 404 if no page was found for the URL or subpart
            raise ::ActionController::RoutingError, "No route matches \"#{request.path}\"" if @page.nil?
          end
        end
      # Find page by id
      elsif not params[:id].blank?
        # Render page by id if not webpath was given but an id
        @page = Page.find(params[:id])
      # Find root page
      else
        # Render index page if neither id or webpath was given
        @page = Page.find_by_name('index')
        unless @page
          render '/humpyard/pages/welcome'
          return false
        end
      end
      
      # Raise 404 if no page was found
      raise ::ActionController::RoutingError, "No route matches \"#{request.path}\"" if @page.nil?    
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

        Humpyard.config.locales.each do |locale|
          add_to_sitemap xml, base_url, locale, Page.roots
        end
        #add_page xml, url_for(:controller => 'customer/home'), last_mod, 0.8
      end
      render :xml => xml.target!
    end

    private
    def add_to_sitemap xml, base_url, locale, pages, priority=0.8, changefreq='daily' 
      pages.each do |page|
        lastmod = page.last_modified
        xml.tag! :url do
          xml.tag! :loc, "#{base_url}#{page.human_url :locale=>locale}"
          xml.tag! :lastmod, lastmod.to_time.strftime("%FT%T%z").gsub(/00$/,':00')
          xml.tag! :changefreq, changefreq
          xml.tag! :priority, page.name == 'index' ? 1.0 : priority
          #xml.tag! :wetwerwerw, 'does not validate'
        end
      
        add_to_sitemap xml, base_url, locale, page.children, priority/2
      end
    end
    
    def check_login
      if params[:fake_login] == 'true'
        @humpyard_fake_login = true
      end
    end
  end
end