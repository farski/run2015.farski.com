Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  root to: 'graphs#rickshaw'

  get 'leaderboard' => 'dashboard#leaderboard'
  get 'graph' => 'graphs#rickshaw'
  get 'stats' => 'dashboard#stats'
  get 'signup' => 'dashboard#index'

  get 'import/update' => 'import#update'
  get 'update' => 'import#update'
end
