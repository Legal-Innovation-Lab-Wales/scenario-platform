Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :users

  root 'pages#main'
  get '/app', to: 'pages#app', as: 'app'
  get '/edit', to: 'registrations#edit', as: 'edit'
  
  resources :quizzes
  #get '/quizzes', to: 'quizzes#index'

end
