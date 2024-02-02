require "sidekiq/web"

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', registrations: 'oauth_registrations' }

  resources :questions do
    resources :answers, shallow: true do
      resources :comments, shallow: true, defaults: { commentable: 'answer' }
    end
    resources :comments, shallow: true, defaults: { commentable: 'question' }
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[index show create], shallow: true
      end
    end
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
