Rails.application.routes.draw do
  get 'homepage/index'
  root 'homepage#index'
  devise_for :users
  get 'pages/main'
  get 'pages/about'
  get 'pages/user_profile'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
