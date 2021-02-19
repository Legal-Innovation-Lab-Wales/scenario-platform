Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'pages#main'
  get '/app', to: 'pages#app', as: 'app'
  get '/guide', to: 'pages#guide', as: 'guide'

  devise_for :users, :controllers => {:registrations => 'users/registrations'}

  namespace :admin do
    root 'pages#main'
    put '/organisation', to: 'organisation#update_name'
    get '/users/:id/scores', to: 'users#scores'
    put '/users/:id/approve', to: 'users#approve'
    put '/users/:id/admin', to: 'users#admin'
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
