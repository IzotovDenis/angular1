Rails.application.routes.draw do


  require 'sidekiq/web'
authenticate :user, lambda { |u| u.role == 'dev' } do
  mount Sidekiq::Web => '/sidekiq'
end

  namespace :admin do
    get '/' => "dashboard#index"
    resources :searches
    resources :offers do
      collection do
        get "app"
      end
    end
    resources :currencies
    resources :rates
    resources :sliders do
      collection do
        post "sort"
      end
    end
    resources :activities
    resources :pcatalogs do
      collection do
        post "sort"
      end
    end
    resources :promos do
      collection do
        post "sort"
      end
    end
    resources :groups do
      collection do
        post "sort"
        patch "sort_items/:id", :action=>'sort_items', as: :sort_items
      end
    end
    resources :items do
      collection do
        post "sort"
      end
    end
    resources :orders, :only => [:index, :show] do
      collection do
        post "", :action=>'index'
        post ":id/forward", :action=>'forward', as: :forward
      end
    end
    resources :users do
      collection do
        post ":id/reset_password", :action=>"reset_password", as: :reset_password
      end
    end
  end

  devise_for :users

  get '1c_import/:exchange_type' => "imports#index"
  post '1c_import/:exchange_type' => "imports#index" 

  root "app#index"

  get 'pricelist.zip' => "api/pricelists#download"

  namespace :api do
    resources :pricelists, :only =>[:index]
    resources :groups, :only =>[:index, :show] do
      collection do 
        get 'tree'
      end
    end
    resources :ping, :only => [:index]
    resources :items, :only => [:show]
    resources :orders, :only => [:index, :show] do
      collection do
        get 'current'
        post 'forwarding'
      end
    end
    resources :order_items
    resources :offers, :only => [:index, :show]
    resources :find
    resources :users, :only => [:index, :update] do
      collection do
        patch 'update_password'
        get 'current'
      end
    end
    resources :brands, :only => [:index, :show]
    resources :posts, :only => [:show]
  end

  get 'dashboard' => "dashboard#index"

  namespace :dashboard do
    namespace :api do
      get "stat"
      resources :rates, :only => [:create]
      resources :orders
      resources :pricelists
      resources :activities do
        collection do
          get "user_online"
        end
      end
      resources :users do
        collection do
          post "update_role"
        end
      end
      resources :offers do
        collection do
          get "get_items"
        end
      end
      resources :groups do
        collection do
          get "tree"
          post "toggle"
        end
      end
      resources :sliders
      resources :currencies
      resources :posts do
        collection do
          post "sort"
        end
      end
    end
  end

  get '*path', to: 'app#index'
end
