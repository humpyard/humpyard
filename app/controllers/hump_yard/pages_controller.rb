module HumpYard
  class PagesController < ApplicationController 
    #self.template_root = File.join(File.dirname(__FILE__), '..', 'views')

    def index
  
    end

    def new
      render :text=>'test'
    end
    
    def show
      @page = nil
      if params[:id]
        @page = Page.find(params[:id])
      elsif params[:name]
        @page = Page.find_by_name(params[:name])
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