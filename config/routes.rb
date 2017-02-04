Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users, only: [:index, :show, :edit, :update] do
    resources :trainings, controller: 'users/trainings', only: [:index, :create, :update]
  end
  resources :trainings do
    get :invite
    get :invitation_accept
    get :invitation_remove
    put :close
  end
end
