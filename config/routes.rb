Rails.application.routes.draw do
  root "welcome#about"

  get '/signup', to: "registrations#new"
  post '/signup', to: "registrations#create"

  get 'login', to: "sessions#new"
  post '/login', to: "sessions#create"
  delete '/logout', to: "sessions#destroy"

  get 'users/:id', to: "users#show", as: "profile"

  resources :chatrooms, param: :slug
  resources :messages

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  get "manifest.json" => "metadata#manifest", as: :manifest
  get "push-service-worker.js" => "service_workers#push"

  resources :push_notifications do
    collection do
      post 'subscribe'
      post 'unsubscribe'
    end
  end
end
