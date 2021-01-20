Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'pages#main'
  get '/app', to: 'pages#app', as: 'app'

  devise_for :users

  namespace :admin do
    resources :users
  end

  resources :quizzes do
    resources :questions do
      resources :answers
    end
  end

end