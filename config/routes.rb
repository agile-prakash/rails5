require 'api_constraints'
Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  namespace :api, defaults: { format: :json }, constraints: { localhost: 'api' }, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      root to: 'home#index', as: 'api_home'
      resources :brands, only: [:index, :show]
      resources :services, only: [:index, :show]
      resources :tags, only: [:index, :show, :create] do
        collection { get :exact }
        member { get :posts }
      end
      resources :categories, only: [:index, :show]
      resources :certificates, only: [:index, :show]
      resources :products, only: [:index, :show]
      resources :degrees, only: [:index, :show]
      resources :lines, only: [:index, :show]
      resources :harmonies, only: [:index]
      resources :experiences, only: [:index]
      resources :salons, except: [:edit] do
        member { get :stylists }
      end
      resources :contacts, except: [:edit]
      resources :folios, only: [:index, :create, :destroy, :update] do
        member do
          get :posts
          post :add_post
          delete :remove_post
        end
      end
      resources :posts do
        resources :comments, only: [:create, :destroy, :index, :update]
        resources :likes, only: [:create, :index] do
          collection { delete :destroy }
        end
      end
      resources :products do
        # resources :comments, only: [:create, :destroy, :index, :update]
        resources :favourites, only: [:create, :index] do
          collection { delete :destroy }
        end
      end
      
      

      resources :photos, only: [:update]
      resources :notifications, only: [:index, :show]
      resources :users, except: [:edit] do
        resources :educations, except: [:edit]
        resources :offerings, except: [:edit]
        member do
          get :posts
          get :folios
        end
        resources :follows, only: [:create, :index] do
          collection { delete :destroy }
        end
        resources :blocks, only: [:create, :index] do
          collection { delete :destroy }
        end
        resources :notifications, only: [:index, :destroy]
      end
      resources :conversations, except: [:edit, :show] do
        member { post :read }
        resources :messages, except: [:edit] do
          member { post :read }
        end
      end
      resources :sessions, only: [:create, :destroy] do
        collection do
          get :environment
          post :facebook
          post :instagram
          post :recover
        end
      end
    end
  end
  
  get "/user/likes/:id" => "api/v1/users#user_likes"
  get "/user/favourites/:id" => "api/v1/users#user_favourites"

  get "/404" => "api/v1/errors#not_found"
  get "/500" => "api/v1/errors#exception"

  devise_for :users

  root to: 'home#index'
end
