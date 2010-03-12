Rails.application.routes.draw do |map|
  resources :pages, :controller => 'hump_yard/pages'
  
  
  map.root :controller => 'hump_yard/pages', :action => 'show', :name => 'index'
  map.short_subpage ":locale/*parent/:name.html", :controller => 'hump_yard/pages', :action => 'show'
  map.short_rootpage ":locale/:name.html", :controller => 'hump_yard/pages', :action => 'show'
end