MyBlog::Application.routes.draw do
  #get "storages/new"

  #get "clients/new"

  #get "drivers/new"

  #get "avtos/new"

  #get "companies/new"

  #get "transportations/new"

  resources :users
  resources :sessions, :only => [:new, :create, :destroy]
  resources :transportations #, :only => [:new, :create, :index ]
  resources :companies
  resources :avtos  
  resources :drivers
  resources :storages
  resources :clients
  
  match '/signup',  :to => 'users#new'
	match '/contact', :to => 'pages#contact'
  match '/help',    :to => 'pages#help'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  match '/index',   :to => 'transportations#index'
  #спец. роутинг для подтверждения заявки
  match 'transportations/:id/confirmation', 	:to 	=>  'transportations#confirmation'
  match 'transportations/:id/edit_conf',    	:to 	=>  'transportations#edit_conf'
  match 'transportations/:id/get_storage',  	:to 	=>  'transportations#get_storage'
  match	'transportations/:id/copy',		:to	=>	'transportations#new'
  match	'transportations/:id/packet',		:to	=>	'transportations#packet_loading'
  match	'transportations/:id/load',		:to	=>	'transportations#load'
  match	'transportations/:id/abort',		:to	=>	'transportations#abort'
  match 'transportations/:id/export',		:to 	=>	'transportations#export'
  match 'transportations/:id/specprice',	:to	=>	'transportations#spec_price'
  match 'transportations/:id/request_abort',	:to	=>	'transportations#request_abort'
  match 'transportations/:id/confirm_abort',	:to	=>	'transportations#confirm_abort'
  match 'transportations/:id/server_time',	:to	=>	'transportations#server_time'
  match 'transportations/:id/do_rate',	:to	=>	'transportations#do_rate'
  #match '/home', :to => 'pages#home'
  
  root :to => 'pages#home'
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
