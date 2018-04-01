Rails.application.routes.draw do
  root to: "uploads#new"

  resources :uploads
  resources :templates
end
