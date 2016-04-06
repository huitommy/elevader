Rails.application.routes.draw do
  devise_for :admins
  devise_for :users

  root to: 'elevators#index'
  resources :users

  resources :elevators, only: [:index, :show]

  authenticated :admin do
    resources :admins, only: [:index, :create, :destroy]
    resources :users, only: [:index, :update, :destroy]
  end

  authenticate :user do
    resources :elevators, only: [:new, :create, :update, :destroy, :edit] do
      resources :reviews, only: [:create, :update, :destroy, :edit]
    end
  end
end

# <<<<<<< HEAD
#   resources :elevators do
#     resources :reviews, only: [:create]
#   end

#   resources :reviews, only: [:update, :destroy]


# =======
#   resources :elevators, only: [:index, :show, :new]

#   authenticate :user do
#     resources :elevators, only: [:create, :update, :destroy, :edit] do
#       resources :reviews, only: [:create]
#     end
#     resources :reviews, only: [:update, :destroy, :edit]
#   end
# >>>>>>> 17a9ccaaf9b60105f466721e59edba9911884305
# end
