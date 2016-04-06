Rails.application.routes.draw do
  devise_for :admins
  devise_for :users

  root to: 'elevators#index'
  resources :users

  resources :elevators do
    resources :reviews, only:[ :create ]
  end

  resources :reviews, only:[:update, :destroy]

end
