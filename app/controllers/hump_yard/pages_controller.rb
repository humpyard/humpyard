module HumpYard
  class PagesController < ApplicationController 
    #self.template_root = File.join(File.dirname(__FILE__), '..', 'views')

    def index
  
    end

    def new
      render :text=>'test'
    end
    
    def show
      
    end
  end
end