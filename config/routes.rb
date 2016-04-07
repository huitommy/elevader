Rails.application.routes.draw do
  devise_for :admins
  devise_for :users

  root to: 'elevators#index'
  resources :users

  authenticate :user do
    resources :elevators, only: [:new, :create, :update, :edit] do
      resources :reviews, only: [:create]
    end
    resources :reviews, only: [:edit, :update]
  end

  resources :elevators, only: [:index, :show, :destroy] do
    collection do
      get 'search'
    end
  end
  resources :reviews, only: [:destroy]

  authenticated :admin do
    resources :admins, only: [:index, :create, :destroy]
    resources :users, only: [:index, :update, :destroy]
  end
end
