Rails.application.routes.draw do
  devise_for :users

  root to: 'elevators#index'
  resources :users

end
