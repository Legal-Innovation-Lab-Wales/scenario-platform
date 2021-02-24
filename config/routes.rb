Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'pages#main'
  get '/app', to: 'quizzes#index', as: 'app'
  get '/guide', to: 'pages#guide', as: 'guide'
  get '/terms', to: 'pages#terms'

  devise_for :users, :controllers => {:registrations => 'users/registrations'}

  namespace :admin do
    root 'pages#main'
    put '/organisation', to: 'pages#update_organisation_name'

    get '/quizzes/:quiz_id', to: 'pages#get_quiz'
    get '/quizzes/:quiz_id/users/:user_id', to: 'pages#get_attempts'
    get '/quizzes/:quiz_id/users/:user_id/results/:result_id', to: 'pages#get_result'

    get '/users/:user_id', to: 'pages#get_user'
    put '/users/:user_id/approve', to: 'pages#approve_user'
    put '/users/:user_id/admin', to: 'pages#set_admin'
  end

  resources :quizzes do
    resources :questions do
      resources :answers
    end
  end

  post 'start_quiz', to: 'quiz_attempts#start_quiz'
  put 'resume_quiz', to: 'quiz_attempts#resume_quiz'
  put 'select_answer', to: 'quiz_attempts#select_answer'
  get '/quizzes/:quiz_id/results/:quiz_attempt_id', to: 'results#show', as: 'show_results'

end
