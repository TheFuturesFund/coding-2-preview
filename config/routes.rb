Rails.application.routes.draw do
  get 'comments/create'

  resources :posts do
    resources :comments, only: :create
  end

  root to: "posts#index"
end
