Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', registrations: 'oauth_registrations' }

  resources :questions do
    resources :answers, shallow: true do
      resources :comments, shallow: true, defaults: { commentable: 'answer' }
    end
    resources :comments, shallow: true, defaults: { commentable: 'question' }
  end

  resources :links, only: :destroy
  resources :rewards, only: :index

  root to:'questions#index'

  get 'answer_best', to: 'answers#best'
  get 'my_rewards', to: 'rewards#index'

  post 'like', to: 'likes#like', as: 'rate'

  delete 'files/:id/purge', to: 'files#purge', as: 'purge_file'

  mount ActionCable.server => '/cable'
end
