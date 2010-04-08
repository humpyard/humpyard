Rails.application.routes.draw do |map|
  # Map admin controllers
  
  # Workaround as the create route does not seem to work with latest rails
  match "/#{Humpyard::config.admin_prefix}/element/create(.:format)" => 'humpyard/elements#create'
  match "/#{Humpyard::config.admin_prefix}/page/create(.:format)" => 'humpyard/pages#create'
  
  scope "/#{Humpyard::config.admin_prefix}" do 
    resources :humpyard_pages, :controller => 'humpyard/pages', :path => :pages, :only => [:index, :new, :create, :edit, :update, :show, :destroy] do
      member do
        post :move
      end
    end
    resources :humpyard_elements, :controller => 'humpyard/elements', :path => :elements, :only => [:new, :create, :edit, :update, :show, :destroy] do
      member do
        get :inline_edit
        post :move
      end
    end
  end
  
  # Map "/" URL
  root :to => 'humpyard/pages#show'
  # Map sitemap.xml
  match "/sitemap.xml" => 'humpyard/pages#sitemap', :as => 'sitemap'
  # Map human readable page URLs
  if Humpyard::config.www_prefix.match /:locale/
    match "/#{Humpyard::config.www_prefix}" => 'humpyard/pages#show', :constraints => { :locale => Humpyard.config.locales_contraint}    
    match "/#{Humpyard::config.www_prefix}*webpath.html" => 'humpyard/pages#show', :constraints => { :locale => Humpyard.config.locales_contraint}
  else
    match "/#{Humpyard::config.www_prefix}*webpath.html" => 'humpyard/pages#show'    
  end

end
