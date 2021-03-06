require 'sidekiq/web'

Rails.application.routes.draw do

  get 'search/index'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks'}

  root to: 'questions#index'

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  concern :commentable do
    member do
      post :comment
    end
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :subscriptions, shallow: true, only: %i[create destroy]
    resources :answers, shallow: true, concerns: %i[votable commentable] do

      member do
        patch :best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me, on: :collection
      end
      resources :questions, only: %i[index show create update destroy] do
        resources :answers, shallow: true, only: %i[index show create update destroy]
      end
    end
  end

  mount ActionCable.server => '/cable'

  resources :search, only: :index
end
