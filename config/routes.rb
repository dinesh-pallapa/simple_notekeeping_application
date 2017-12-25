Rails.application.routes.draw do
  devise_for :users
  root 'notes#index'

  resources :notes
  get "tags/:tag", to: "notes#index", as: "tag"
end
