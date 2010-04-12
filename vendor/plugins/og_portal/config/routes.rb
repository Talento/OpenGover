#Rails.application.routes.draw do |map|
##  resources :templates
##  resources :pages
##  match 'templates(/:action(/:id(.:format)))' => 'templates'
##  match 'pages(/:action(/:id(.:format)))' => 'pages'
#
#
#
#
#
#
#  match '(:og_locale/)(private/:user_login/)(site/:og_site_id/):controller(/:action(/:id(.:format)))', :og_locale => Regexp.new(I18n.available_locales.collect(&:to_s).join("|"))
#
#
#
#
#  root :to => 'pages#show'
#end