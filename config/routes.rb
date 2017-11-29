Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    resources :lectures, only: [:index, :show] do
      resources :evaluations, only: [:index, :create, :update, :destroy]
    end

    resource :user, only: [:show, :create, :update, :destroy] do
      post :sign_in, to: 'auth#sign_in'
      delete :sign_out, to: 'auth#sign_out'

      resource :reset_password, only: [:create, :update]
      resource :confirmation, path: 'confirm_email', only: [:create, :update]
    end
  end

  get 'healthz', to: 'health#index'
end
