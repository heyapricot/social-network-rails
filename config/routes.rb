Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: %i[show index] do
    resources :posts, only: %i[create]
    resources :friendships, only: %i[create]
  end
  resources :posts, only: %i[create index show] do
    resources :comments, only: %i[create], controller: :post_actions
    resources :likes, only: %i[create], controller: :post_actions
  end
  resources :friendships, only: :update

  root to: 'posts#index'

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
  end
end