Rails.application.routes.draw do

  devise_for :users
  root 'notes#index'

  resources :notes
  resources :note_permissions
  get "tags/:tag", to: "notes#index", as: "tag", :constraints  => { :tag => /[^\/]+/ }
end
