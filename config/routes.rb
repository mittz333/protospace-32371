Rails.application.routes.draw do
  devise_for :users
  root to: "prototypes#index"
  # resources :prototypes, only: [:new, :create, :show, :edit, :update, :destroy, :post]
  # resources :comments, only: [:create]
  resources :prototypes do
    resources :comments, only: :create
  end
  resources :users, only: :show

end
