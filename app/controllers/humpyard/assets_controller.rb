module Humpyard
  class AssetsController < ::ApplicationController
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
    
    def index
      @assets = Humpyard::Asset.all
      
      authorize! :manage, Humpyard::Asset
      
      render partial: 'index'
    end
    
    def new     
      raise ::ActionController::RoutingError, 'Asset type not found' if Humpyard::config.asset_types[params[:type]].blank?
      
      @asset = Humpyard::config.asset_types[params[:type]].new()
      
      authorize! :create, @asset.asset 
      
      @asset_type = params[:type]
      
      render partial: 'edit'
    end
    
    def create  
      raise ::ActionController::RoutingError, 'Asset type not found' if Humpyard::config.asset_types[params[:type]].blank?
      
      @asset = Humpyard::config.asset_types[params[:type]].new params[:asset]
            
      authorize! :create, @asset.asset 
          
      if @asset.save
        @assets = Humpyard::Asset.all
        render json: {
          status: :ok,
          replace: [{
            element: "hy-asset-listview",
            content: render_to_string(partial: "list.html", locals: {assets: @assets, asset: @asset})
          }],
          flash: {
            level: 'info',
            content: I18n.t('humpyard_form.flashes.create_success', model: Humpyard::Asset.model_name.human)
          }
        }
      else
        render json: {
          status: :failed, 
          errors: @asset.errors,
          flash: {
            level: 'error',
            content: I18n.t('humpyard_form.flashes.create_fail', model: Humpyard::Asset.model_name.human)
          }
        }
      end
    end
    
    def edit
      raw_asset = Humpyard::Asset.find(params[:id])
      
      authorize! :update, raw_asset
      
      @asset = raw_asset.content_data
      
      render partial: 'edit'
    end
    
    def update
      @asset = Humpyard::Asset.find(params[:id])

      authorize! :update, @asset

      if @asset.content_data.update_attributes params[:asset]
        render json: {
          status: :ok,
          replace: [
            { 
              element: "hy-asset-listview-text-#{@asset.id}",
              content: render_to_string(partial:'list_item.html', locals: {asset: @asset, active: true})
            }
          ],
          flash: {
            level: 'info',
            content: I18n.t('humpyard_form.flashes.update_success', model: Humpyard::Asset.model_name.human)
          }
        }
      else
        render json: {
          status: :failed, 
          errors: @asset.content_data.errors,
          flash: {
            level: 'error',
            content: I18n.t('humpyard_form.flashes.update_fail', model: Humpyard::Asset.model_name.human)
          }
        }
      end
    end
    
    def show
      raw_asset = Humpyard::Asset.find(params[:id])
      
      authorize! :show, raw_asset
      
      @asset = raw_asset.content_data
      
      render partial: 'show'
    end
    
    def destroy
      @asset = Humpyard::Asset.find(params[:id])
      
      authorize! :destroy, @asset  
      
      @asset.destroy
      
      render json: {
        status: :ok
      }
    end
    
    def versions
      asset = Humpyard::Asset.find(params[:id])
      
      authorize! :show, asset
      
      render json: {status: :ok, versions: asset.versions.map{|k,v| v ? ["#{k.to_s.camelcase} (#{v * 'x'})", k.to_s] : ['','']}}
    end
  end
end