Rails.application.routes.draw do
  resources :messages
  namespace :api do
    namespace :v1 do
      resources :users
      post '/login', to: "auth#login"
      post '/register', to: "auth#register"
      post '/logout', to: "auth#logout"
      post ':userid/create_message', to: 'messages#create'
      get '/users/:userid/message', to: 'messages#show'
    end
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
