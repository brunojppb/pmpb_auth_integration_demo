Rails.application.routes.draw do
  resources :roles

  get 'login', to: 'sessions#index'
  get 'login_callback', to: 'sessions#login_callback'
  get 'logout' , to: 'sessions#logout'

  # API Universal de controle de papeis/permissões
  get     '/permissions/roles', to: 'permissions#index'                      
  get     '/permissions/user/:registration/roles', to: 'permissions#show'
  post    '/permissions/user/:registration/roles', to: 'permissions#update'
end
