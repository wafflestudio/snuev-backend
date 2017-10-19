Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1, defaults: { format: :json } do
    devise_for :users
    resources :lectures, only: [:index, :show] do
      resources :evaluations, only: [:index, :create, :update, :destroy]
    end
  end
end
