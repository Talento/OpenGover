Rails.application.routes.draw do |map|
#  resources :templates
#  resources :pages
  match 'templates(/:action(/:id(.:format)))' => 'templates'
  match 'pages(/:action(/:id(.:format)))' => 'pages'
end