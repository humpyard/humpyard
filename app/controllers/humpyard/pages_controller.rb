module Humpyard
  class PagesController < ApplicationController 
    #self.template_root = File.join(File.dirname(__FILE__), '..', 'views')

    def index
  
    end

    def new
      render :text=>'test'
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
  end
end