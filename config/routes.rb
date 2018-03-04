Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    resources :courses, only: [:index] do
      get :search, on: :collection
    end
    resources :lectures, only: [:index, :show] do
      resources :evaluations, only: [:index, :create, :update, :destroy] do
        get :mine, on: :collection

        resource :vote, only: [:create, :destroy]
      end
      resource :bookmark, only: [:create, :destroy]

      collection do
        get :bookmarked
        get :search
      end
    end

    resources :evaluations, only: [] do
      collection do
        get :latest
        get :mine
      end
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
