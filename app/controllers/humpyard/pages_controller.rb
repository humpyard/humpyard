module Humpyard
  class PagesController < ApplicationController 
    def index
      
    end

    def new
      
    end
    
    def create
      
    end
    
    def edit
    
    end
    
    def modify
      
    end
    
    def show
      # No page found at the beginning
      @page = nil
      if not params[:webpath].blank?
        params[:webpath].split('/').each do |path_part|
          # Ignore multiple slashes in URLs
          unless(path_part.blank?)
            # Find page by name and parent; parent=nil means page on root level
            @page = Page.where(:parent_id=>@page, :name=>path_part).first
            # Raise 404 if no page was found for the URL or subpart
            if @page.nil?
              render('404', :status => 404) 
              return
            end
          end
        end
      elsif not params[:id].blank?
        # Render page by id if not webpath was given but an id
        @page = Page.find(params[:id])
      else
        # Render index page if neither id or webpath was given
        @page = Page.find_by_name('index')
      end

      # Raise 404 if no page was found
      render('404', :status => 404) if @page.nil?      
    end
  
    def sitemap
      require 'builder'
      
      xml = ::Builder::XmlMarkup.new :indent => 2
      xml.instruct!
      xml.tag! :urlset, {
        'xmlns'=>"http://www.sitemaps.org/schemas/sitemap/0.9",
        'xmlns:xsi'=>"http://www.w3.org/2001/XMLSchema-instance",
        'xsi:schemaLocation'=>"http://www.sitemaps.org/schemas/sitemap/0.9\nhttp://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd"
      } do

        last_mod = ::File.new("#{Rails.root}").mtime
        base_url = "#{request.protocol}#{request.host}#{request.port==80 ? '' : ":#{request.port}"}"

        add_to_sitemap xml, base_url, Page.roots, last_mod
        #add_page xml, url_for(:controller => 'customer/home'), last_mod, 0.8
      end
      render :xml => xml.target!
    end

    private
    def add_to_sitemap xml, base_url, pages, lastmod, priority=0.8, changefreq='daily'
      pages.each do |page|
        xml.tag! :url do
          xml.tag! :loc, "#{base_url}#{page.human_url}"
          xml.tag! :lastmod, lastmod.to_time.strftime("%FT%T%z").gsub(/00$/,':00')
          xml.tag! :changefreq, changefreq
          xml.tag! :priority, page.name == 'index' ? 1.0 : priority
          #xml.tag! :wetwerwerw, 'does not validate'
        end
      
        add_to_sitemap xml, base_url, page.children, lastmod, priority/2
      end
    end
  end
end