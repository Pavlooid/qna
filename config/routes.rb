Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, shallow: true
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
