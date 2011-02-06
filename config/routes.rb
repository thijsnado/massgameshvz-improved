Massgameshvz::Application.routes.draw do

  get "welcome/index"

  resources :games
  resources :users
  resources :user_sessions
  resources :self_bites
  resources :bites do
    new do
      get :receive
      get :give
    end
  end
  resources :vaccines
  
  match "login", :to => "user_sessions#new"
  match "logout", :to => "user_sessions#destroy"
  match "register", :to => "users#new"
  match "resend_confirmation", :to => 'TODO'
  match "admin", :to => 'admin#index'
  match "profile", :to => "users#index"
  
  namespace :admin do
    resources :living_areas
    resources :humans
    resources :zombies
    resources :original_zombies, :member => {:make_zombie => :put, :make_regular => :put}
    resources :vaccines
    resources :pseudo_bites
    resources :users, :collection => {:get_creatures => :get}
    resources :sarcastic_comments
    resources :game_attributes 
    resources :events
    resource :mailer, :member => {:sender => :post}
    
    #misc admin tasks, not really a resource but easier to work with this way
    resources :misc_tasks
  end

  root :to => "welcome#index"
end
