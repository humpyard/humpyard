Rails.application.routes.draw do |map|
  # Map admin controllers
  scope "/#{Humpyard::config.admin_prefix}" do 
    resources :pages, :controller => 'humpyard/pages'
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