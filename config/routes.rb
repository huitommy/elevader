Rails.application.routes.draw do
  devise_for :admins
  devise_for :users

  root to: 'elevators#index'
  resources :users

  resources :elevators do
    resources :reviews, only: [:create]
  end

  resources :reviews, only: [:update, :destroy]

  authenticated :admin do
    resources :admins, only: [:index, :create, :destroy]
    resources :users, only: [:index]
  end

end
