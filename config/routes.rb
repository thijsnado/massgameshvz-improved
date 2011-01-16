Massgameshvz::Application.routes.draw do
  get "welcome/index"

  resources :games
  resources :users
  resources :user_sessions
  
  match "login", :to => "user_sessions#new"
  match "logout", :to => "user_sessions#destroy"
  match "register", :to => "users#new"
  match "resend_confirmation", :to => 'TODO'
  match "admin", :to => 'TODO'
  match "profile", :to => "users#index"
  

  root :to => "welcome#index"
end
