Rails.application.routes.draw do |map|
  resources :pages, :controller => 'hump_yard/pages'
end