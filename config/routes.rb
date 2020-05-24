Rails.application.routes.draw do
  resources :questions do
    resource :answers, shallow: true
  end
end
