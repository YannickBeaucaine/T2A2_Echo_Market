Rails.application.routes.draw do
  # setting route for listing page
  resources :listings
  # setting route for devise
  devise_for :users
  # setting route for stripe payment
  get '/purchases/success', to: 'purchases#success'
  # route for ultrahook and stripe webhook connection
  post '/purchases/webhook', to: 'purchases#webhook'
  # setting index page
  root 'home#page'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
