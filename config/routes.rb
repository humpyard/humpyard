Rails.application.routes.draw do |map|
 
  scope "/#{Humpyard::config.admin_prefix}" do 
    resources :pages, :controller => 'humpyard/pages'
  end
  
  root :to => 'humpyard/pages#show'
  match "/#{Humpyard::config.www_prefix}*webpath.html" => 'humpyard/pages#show'
  #match "/#{Humpyard::config.www_prefix}:name.html" => 'humpyard/pages#show'
end