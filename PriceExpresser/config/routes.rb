Rails.application.routes.draw do

  get 'password_resets/new'

  get 'welcome/index'
  get 'products/index_others', :controller => 'products', :action => 'index_others'
  get 'products/index_appliances', :controller => 'products', :action => 'index_appliances'
  get 'products/index_electronic', :controller => 'products', :action => 'index_electronic'
  get 'search', to: 'search#search'
  get 'prices/index', :controller => 'prices', :action => 'index'
  

  get 'locations/walmarts', :controller => 'locations', :action => 'walmarts'
  get 'locations/costcos', :controller => 'locations', :action => 'costcos'
  get 'locations/bestbuys', :controller => 'locations', :action => 'bestbuys'
  get 'locations/superstores', :controller => 'locations', :action => 'superstores'
  resources :locations
  
  resources :password_resets

  resources :products do
    resource :prices
    resource :subs
  end
  get '/products/:id/statAmazon', :to => 'products#statAmazon', :as => 'statAmazon_product'
 get '/products/:id/statEBay', :to => 'products#statEBay', :as => 'statEBay_product'
  get '/products/:id/statWalmart', :to => 'products#statWalmart', :as => 'statWalmart_product'
  resources :contacts
  
  default_url_options :host => "localhost:8080"
  resources :users do
    member do
      get :confirm_email
    end
  end
  get 'sessions/new'
  #get 'welcome/index'
  #get 'welcome/help'
  get 'help' => 'welcome#help'
  #get 'welcome/about'
  get 'about' => 'welcome#about'

  get 'users/:id' => 'users#show'
  get 'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  resources :orders # think about using get method

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  root 'welcome#index'
  #get '*path' => redirect('/') # redirect any error path to the home page
  get '*unmatched_route', to: 'application#raise_not_found'
  #get '', to: 'users#show', as: 'user'
  #get 'edit', to: 'users#edit' as: 'user'
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
