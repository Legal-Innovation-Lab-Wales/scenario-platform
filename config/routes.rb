Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'pages#main'
  get '/app', to: 'pages#app', as: 'app'
  get '/guide', to: 'pages#guide', as: 'guide'

  devise_for :users

  namespace :admin do
    resources :users
  end

  resources :quizzes do
    resources :questions do
      resources :answers
    end
  end

  post 'start_quiz', to: 'quiz_attempts#start_quiz'
  put 'resume_quiz', to: 'quiz_attempts#resume_quiz'
  put 'select_answer', to: 'quiz_attempts#select_answer'

end
