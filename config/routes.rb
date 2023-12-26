Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, shallow: true
  end

  root to:'questions#index'

  get 'answer_best', to: 'answers#best'

  delete 'files/:id/purge', to: 'files#purge', as: 'purge_file'
end
