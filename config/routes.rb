Massgameshvz::Application.routes.draw do

  resources :squads do
    collection do
      get :usernames
    end
  end

  get "welcome/index"

  resources :games
  resources :users do
    member do
      get :confirm
    end
    collection do
      post :resend_confirmation
    end
  end
  resources :user_sessions
  resources :self_bites
  resources :bites do
    new do
      get :report
    end
  end
  resources :bite_shares do
    member do
      get :share
    end
    collection do
      get :usernames
    end
  end
  resources :vaccines do
    collection do
      get :enter
      put :take
    end
  end
  resources :events
  
  match "login", :to => "user_sessions#new"
  match "logout", :to => "user_sessions#destroy"
  match "register", :to => "users#new"
  match "admin", :to => 'admin#index'
  match "players", :to => 'games#index'
  
  
  namespace :admin do
    resources :living_areas
    resources :humans
    resources :zombies
    resources :original_zombies do 
     member do
       put 'make_zombie'
       put 'make_regular'
     end
    end
    resources :squads do
      collection do
        get :usernames
      end
    end
    resources :vaccines
    resources :pseudo_bites
    resources :users do
      collection do
        get 'get_creatures'
      end
    end
    resources :sarcastic_comments
    resources :games 
    resources :events
    resources :email_domains
    resource :mailer
    resource :welcome
    
    #misc admin tasks, not really a resource but easier to work with this way
    resources :misc_tasks do
      collection do
        get 'pause_game_form'
        put 'pause_game'
        put 'unpause_game'
        put 'set_unassigned_to_human'
        put 'resurrect_dead'
      end
    end
  end

  root :to => "welcome#index"
end
