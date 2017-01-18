Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :users, only: [:index, :show, :edit, :update] do
    resources :trainings, controller: 'users/trainings', only: [:index, :create, :update]
  end
  resources :trainings do
    get :invite
    get :invitation_accept
    get :invitation_remove
  end
end
