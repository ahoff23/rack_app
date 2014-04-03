RackApp::Application.routes.draw do
  #Set a root page
  root 'static_pages#home'

  #Redefine routes for static pages
  match '/home',    to: 'static_pages#home',     	via: 'get'
  match '/about',   to: 'static_pages#about',    	via: 'get'
  match '/help',    to: 'static_pages#help',     	via: 'get'
  match '/contact',	to: 'static_pages#contact',		via: 'get'

  #Redefine routes for user pages
  match '/signup',	to: 'users#new',				via: 'get'
end
