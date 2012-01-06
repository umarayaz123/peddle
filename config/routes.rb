Peddle::Application.routes.draw do

  resources :feeds

  resources :messages

  resources :orders

  resources :order_details

  resources :carts

  resources :blog_posts do
    resources :blog_comments
    resources :blog_images
    collection do
      get :drafts
    end

    member do
      get :tag
    end
  end

#  get "home/index"

  match "cart_div" => "products#_cart_div"
  match '/admin' => 'admin/store_admin#index', :constraints => { :subdomain => /.+/ }
  match '/admin' => 'admin/store_admin#index'
  match '/' => 'home#index', :constraints => { :subdomain => 'www' }
  match '/' => 'stores#index', :constraints => { :subdomain => /.+/ }
  match '/' => 'home#index'
  match 'cart' => 'stores#cart'
  match 'store/:id' => 'stores#index'
  match '/store' => 'stores#store'
  match 'store/:id' => 'stores#index'
  match '/sysadmin' => 'admin/sys_admins#index'
  match '/next/stores' => 'home#next_stores'
  match '/get_states' => 'home#get_states'
  match '/check_store' => 'home#check_store'
  match '/check_email' => 'home#check_email'
  match '/sales_floor' => 'home#sales_floor'
  match '/features' => 'home#features'
  match '/home' => 'home#home'
  match '/plans' => 'home#plans'
  match '/pages' => 'pages#index'
  match '/purchase_history' => 'pages#purchase_history'
  match '/next/products' => 'stores#next_products'
  match '/google_checkout' => 'google_checkout#google_checkout'
  match '/edit2' => 'pages#edit'
  match '/index_layout' => 'home#index_layout'

#  match "admin/product_details/:id" => "admin/product_details#index"

  devise_for :users, :controllers => {
      :sessions      => "users/sessions",
      :confirmations => "users/confirmations",
      :passwords     => "users/passwords",
      :registrations => "users/registrations",
  }

  devise_scope :user do
    root :to => "users/sessions#new"
    get "login" => "users/sessions#new"
    get "sign_in", :to => "users/sessions#new"
    get "sign_out", :to => "users/sessions#destroy"
    match 'sign_out', :to => "users/sessions#destroy"
    get "log_out", :to => "users/careers#destroy"
    get "sign_up", :to => "users/registrations#new"
  end

  namespace :admin do
    resources :store_admin
    resources :sys_admins
    resources :stores
    resources :users do
      get 'user_image', :on => :collection
      get 'bg_image', :on => :collection
      put 'user_image_update', :on => :collection
      put 'bg_image_update', :on => :collection
    end
    resources :products
    #resources :packages
    resources :product_details
    resources :pages
  end

  resources :stores do
    get 'search_store', :on => :collection
    resources :products
  end

  resources :products do
    get 'search_products', :on => :collection
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.  
  #  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id(.:format)))'
end
