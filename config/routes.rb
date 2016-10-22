Rails.application.routes.draw do
  devise_for :authors
  get 'comments/create'

  resources :posts do
    resources :comments, only: :create
  end

  root to: "posts#index"
end
