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
  match "/#{Humpyard::config.www_prefix}*webpath.html" => 'humpyard/pages#show'
end