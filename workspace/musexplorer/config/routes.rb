Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  #static pages
  root 'static_pages#home'
  get 'about', to: 'static_pages#about', as: :about
  get 'privacy', to: 'static_pages#privacy_policy', as: :privacy
  match '/contact', to: 'contacts#new', via: 'get'
  resources :contacts, only: [:new, :create]
  #users
  devise_for :users
  resources :users, only: [:show, :edit, :update]

  resources :pieces, only: [:show, :index]
  post ':user_id/:piece_id', to: 'pieces#add_piece_user', as: :add_piece_user
  delete ':user_id/:piece_id', to: 'pieces#delete_piece_user', as: :delete_piece_user

  resources :tips, only: [:create, :destroy] do
    member do 
      post 'vote'
    end
  end

  #tags
  resources :tags, only: [:index, :show]
  post 'pieces/:id/tags/new', to: 'tags#new', as: :new_tag

  #taggings
  resources :taggings, only: :none do 
    member do
      post 'vote'
    end
  end
  
  #pieces search
  get 'search', to: 'pieces#search', as: :search
  get 'results', to: 'pieces#search_results', as: :search_results

  #Categories, posts and replies
  get 'posts/search', to: 'posts#search', as: :post_search
  resources :categories, only: [:index, :show] do 
    resources :posts, except: [:index] do
      resources :replies, except: [:index, :show, :new, :edit] do
        member do
          post 'vote'
        end
      end
      member do
        post 'vote'
      end
    end
  end

  post 'flags/:flaggable_type/:flaggable_id', to: 'flags#create', as: :flags
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
