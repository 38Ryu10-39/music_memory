Rails.application.routes.draw do
  root "posts#index"
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  resources :users, only: %i[index new create show destroy]
  resources :posts do
    resources :comments, only: %i[create edit update destroy], shallow: true
  end
  resource :profile, only: %i[show edit update]
end
