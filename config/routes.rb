Rails.application.routes.draw do
  root "posts#index"
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  resources :users, only: %i[index new create show] do
    member do
      get :follows, :followers
    end
    resource :relationships, only: %i[create]
  end
  resources :posts do
    resources :comments, only: %i[create edit update destroy], shallow: true
    resource :like, only: %i[create]
    collection do
      get :likes
    end
  end
  resource :profile, only: %i[show edit update]
  resources :rooms, only: %i[index show create destroy] do
    resource :chat, only: %i[create]
  end
  resources :notifications, only: %i[index update] do
    collection do
      put :all_update_read
      get :already_read
      delete :delete_read
    end
  end
end
