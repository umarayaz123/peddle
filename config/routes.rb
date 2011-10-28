Peddle::Application.routes.draw do

#  get "home/index"

  match '/' => 'admin/store_admin#index', :constraints => { :subdomain => /.+/ }
  match '/' => 'admin/store_admin#index'
  match '/' => 'home#index', :constraints => {:subdomain => 'www'}
  match '/' => 'home#index', :constraints => { :subdomain => /.+/ }
  match '/' => 'home#index'

  devise_for :users, :controllers => {
    :sessions => "users/sessions",
    :confirmation => "users/confirmations",
    :passwords => "users/passwords",
    :registrations => "users/registrations",
  }

  devise_scope :user do
    root :to => "users/sessions#new"
    get "login" => "users/sessions#new"
    get "sign_in", :to => "users/sessions#new"
    get "sign_out", :to => "users/sessions#destroy"
    match 'sign_out',  :to => "users/sessions#destroy"
    get "log_out", :to => "users/careers#destroy"
    get "sign_up", :to => "users/registrations#new"    
  end


  namespace :admin do
    resources :store_admin
    resources :products
  end
  
  resources :stores do
  	resources :products
  end
  
  resources :products
  
  resources :packages

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
