Rails.application.routes.draw do
  scope '/api' do
    mount_devise_token_auth_for 'User', at: 'auth'
    #, skip: [:omniauth_callbacks]


    default_actions = [:index, :show, :create, :update]

    resources :users, only: [:show, :update]
    post '/update_avatar' => 'users#update_avatar'
    get '/find_users_by_team' => 'users#find_users_by_team'
    resources :user_results, only: :create
    resources :tournaments, only: default_actions
    post '/tournaments_destroy' => 'tournaments#destroy'
    resources :teams, only: [:index, :show, :new, :create]
    resources :matches, only: [:create]
  end
end
