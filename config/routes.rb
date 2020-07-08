Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    member do
      post :vote_up
      post :vote_down
    end

    resources :answers, shallow: true, only: %i[create update destroy] do

      member do
        patch :best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index
end
