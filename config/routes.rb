Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions" }

  root to: 'elevators#index'

  resources :elevators do
    resources :reviews, only:[ :create ]
  end

  resources :reviews, only:[:update, :destroy]
end
