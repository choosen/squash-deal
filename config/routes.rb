Rails.application.routes.draw do
  authenticated do
    root to: redirect { |params, request|
      "users/#{request.env["warden"]&.user&.id || ''}"
    }
  end

  root to: 'home#index'
  get '/home', to: 'home#index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users, only: [:index, :show, :edit, :update] do
    resources :trainings, controller: 'users/trainings', only: [:create, :update]
    resources :trainings, controller: 'users/trainings', only: [:index], constraints: lambda { |req| req.format == :json }
  end
  resources :trainings do
    member do
      get :invite
      get :invitation_accept
      get :invitation_remove
      put :close
    end
  end
end
