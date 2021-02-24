Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'pages#main'
  get '/app', to: 'scenarios#index', as: 'app'
  get '/guide', to: 'pages#guide', as: 'guide'
  get '/terms', to: 'pages#terms'

  devise_for :users, :controllers => {:registrations => 'users/registrations'}

  namespace :admin do
    root 'pages#main'
    put '/organisation', to: 'pages#update_organisation_name'

    get '/scenarios/:scenario_id', to: 'pages#get_scenario'
    get '/scenarios/:scenario_id/users/:user_id', to: 'pages#get_attempts'
    get '/scenarios/:scenario_id/users/:user_id/results/:result_id', to: 'pages#get_result'

    get '/users/:user_id', to: 'pages#get_user'
    put '/users/:user_id/approve', to: 'pages#approve_user'
    put '/users/:user_id/admin', to: 'pages#set_admin'
  end

  resources :scenarios do
    resources :questions do
      resources :answers
    end
  end

  post 'start_scenario', to: 'attempts#start_scenario'
  put 'resume_scenario', to: 'attempts#resume_scenario'
  put 'select_answer', to: 'attempts#select_answer'
  get '/scenarios/:scenario_id/results/:attempt_id', to: 'results#show', as: 'show_results'

end
