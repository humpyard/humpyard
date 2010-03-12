module Humpyard
  class PagesController < ApplicationController 
    #self.template_root = File.join(File.dirname(__FILE__), '..', 'views')

    def index
  
    end

    def new
      render :text=>'test'
    end
    
    def show
      @page = nil
      if not params[:id].blank?
        @page = Page.find(params[:id])
      elsif not params[:name].blank?
        @page = Page.find_by_name(params[:name])
      else
        @page = Page.find_by_name('index')
      end

      if params[:parent] and @page
        parent = @page.parent
        if params[:parent].class == Array
          params[:parent].reverse.each do |p|
            @page = nil if parent.nil? or parent.name != p
            parent = parent.parent unless parent.nil?
          end
        else
          @page = nil if parent.name != params[:parent]
        end
        @page = nil unless parent.nil?
      end

      render('404', :status => 404) if @page.nil?      
    end
  end
end