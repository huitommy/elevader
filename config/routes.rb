Rails.application.routes.draw do
  devise_for :users

  root to: 'elevators#index'
  resources :users

  resources :elevators, only: [:index, :show, :new]

  authenticate :user do
    resources :elevators, only: [:create, :update, :destroy, :edit] do
      resources :reviews, only: [:create]
    end
    resources :reviews, only: [:update, :destroy, :edit]
  end
end
