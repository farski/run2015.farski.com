Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  root to: 'dashboard#index'

  # get 'leaderboard' => 'dashboard#leaderboard'
  # get 'graph' => 'graphs#rickshaw'
  # get 'stats' => 'dashboard#stats'
  get 'signup' => 'dashboard#index'

  # get 'import/update' => 'import#update'
  # get 'update' => 'import#update'

  get 'activities' => 'activities#index'

  get 'strava/webhook' => 'webhooks#get'
  post 'strava/webhook' => 'webhooks#post'

  resources :users

end
