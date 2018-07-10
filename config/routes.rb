Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :home, only: :index
  resources :users, only: %i[show index] do
    resources :posts, only: %i[create]
    resources :friendship_requests, only: %i[create]
  end
  resources :posts, only: %i[create] do
    resources :comments, only: %i[create], controller: :post_actions
    resources :likes, only: %i[create], controller: :post_actions
  end

  root to: 'home#index'

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
  end
end