Rails.application.routes.draw do
  # Map admin controllers
  
  scope "/#{Humpyard::config.admin_prefix}" do 
    resources :humpyard_pages, :controller => 'humpyard/pages', :path => "pages", :only => [:index, :new, :create, :edit, :update, :show, :destroy] do
      collection do
        post :move
      end
    end
    resources :humpyard_elements, :controller => 'humpyard/elements', :path => "elements", :only => [:new, :create, :edit, :update, :show, :destroy] do
      member do
        get :inline_edit
      end
      collection do
        post :move
      end
    end
  end
  
  # Map "/" URL
  root :to => 'humpyard/pages#show', :name => 'index'
  # Map sitemap.xml
  match "/sitemap.xml" => 'humpyard/pages#sitemap', :as => 'sitemap'
  # Map human readable page URLs
  if Humpyard::config.www_prefix.match /:locale/
    match "/#{Humpyard::config.www_prefix}" => 'humpyard/pages#show', :name => 'index', :constraints => { :locale => Humpyard.config.locales_contraint }
    match "/#{Humpyard::config.www_prefix}*webpath.:format" => 'humpyard/pages#show', :constraints => { :locale => Humpyard.config.locales_contraint, :format => Humpyard.config.page_formats_contraint }
  else
    match "/#{Humpyard::config.www_prefix}*webpath.:format" => 'humpyard/pages#show', :constraints => { :format => Humpyard.config.page_formats_contraint }
  end

end
