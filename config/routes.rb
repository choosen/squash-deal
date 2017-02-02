Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :users, only: [:index, :show, :edit, :update] do
    resources :trainings, controller: 'users/trainings', only: [:create, :update]
    resources :trainings, controller: 'users/trainings', only: [:index], constraints: lambda { |req| req.format == :json }
  end
  resources :trainings do
    get :invite
    get :invitation_accept
    get :invitation_remove
    put :close
  end
end
