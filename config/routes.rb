Rails.application.routes.draw do
  devise_for :users
  get 'pages/main'
  get 'pages/about'
  get 'pages/user_profile'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :users,  path: '',
                      path_names: {sign_in: 'login', sign_out: 'logout', edit: 'profile'},
                      controllers: {
                        registrations: 'users/registrations',
                        sessions: 'users/sessions',
                        confirmations: 'users/confirmations'
                      }
  devise_scope :user do
    get '/confirmation/pending', to: 'users/confirmations#pending'
  end
  
  resources :quizzes
  #get '/quizzes', to: 'quizzes#index'

end
