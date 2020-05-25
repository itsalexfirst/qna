Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resource :answers, shallow: true
  end

  root to: 'questions#index'
end
