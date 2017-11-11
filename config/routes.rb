Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'v1/user'

  namespace :v1, defaults: { format: :json } do
    resources :courses, only: [:index]
    resources :lectures, only: [:index, :show] do
      resources :evaluations, only: [:index, :create, :update, :destroy]
    end
    resource :user, only: [:show]
  end
end
