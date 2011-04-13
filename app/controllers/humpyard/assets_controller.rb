module Humpyard
  class AssetsController < ::ApplicationController
    def index
      @assets = Humpyard::Asset.all
      
      render :partial => 'index'
    end
    
    def new     
      @asset = Humpyard::config.asset_types[params[:type]].new()
      
      authorize! :create, @asset.asset 
      
      @asset_type = params[:type]
      
      render :partial => 'edit'
    end
    
    def create  
      @asset = Humpyard::config.asset_types[params[:type]].new params[:asset]
            
      unless can? :create, @asset.asset
        render :json => {
          :status => :failed
        }, :status => 403
        return
      end
          
      if @asset.save
        @assets = Humpyard::Asset.all
        render :json => {
          :status => :ok,
          :replace => [{
            :element => "hy-asset-listview",
            :content => render_to_string(:partial => "list.html", :locals => {:assets => @assets, :asset => @asset})
          }],
          :flash => {
            :level => 'info',
            :content => I18n.t('humpyard_form.flashes.create_success', :model => Humpyard::Asset.model_name.human)
          }
        }
      else
        render :json => {
          :status => :failed, 
          :errors => @asset.errors,
          :flash => {
            :level => 'error',
            :content => I18n.t('humpyard_form.flashes.create_fail', :model => Humpyard::Asset.model_name.human)
          }
        }
      end
    end
    
    def edit
      @asset = Humpyard::Asset.find(params[:id]).content_data
      
      authorize! :update, @asset.asset
      
      render :partial => 'edit'
    end
    
    def update
      @asset = Humpyard::Asset.find(params[:id])
      if @asset 
        unless can? :update, @asset
          render :json => {
            :status => :failed
          }, :status => 403
          return
        end

        if @asset.content_data.update_attributes params[:asset]
          render :json => {
            :status => :ok,
            :replace => [
              { 
                :element => "hy-asset-listview-text-#{@asset.id}",
                :content => render_to_string(:partial =>'list_item.html', :locals => {:asset => @asset, :active => true})
              }
            ],
            :flash => {
              :level => 'info',
              :content => I18n.t('humpyard_form.flashes.update_success', :model => Humpyard::Asset.model_name.human)
            }
          }
        else
          render :json => {
            :status => :failed, 
            :errors => @asset.content_data.errors,
            :flash => {
              :level => 'error',
              :content => I18n.t('humpyard_form.flashes.update_fail', :model => Humpyard::Asset.model_name.human)
            }
          }
        end
      else
        render :json => {
          :status => :failed,
          :flash => {
            :level => 'error',
            :content => I18n.t('humpyard_form.flashes.not_found', :model => Humpyard::Asset.model_name.human)
          }
        }, :status => 404
      end
    end
    
    def show
      @asset = Humpyard::Asset.find(params[:id]).content_data
      
      authorize! :show, @asset.asset
      
      render :partial => 'show'
    end
    
    def destroy
      @asset = Humpyard::Asset.find(params[:id])
      
      authorize! :destroy, @asset  
      
      @asset.destroy
    end
  end
end