Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    resources :lectures, only: [:index, :show] do
      resources :evaluations, only: [:index, :create, :update, :destroy]
    end
    resource :user, only: [:show]
  end

  get 'healthz', to: 'health#index'
end
