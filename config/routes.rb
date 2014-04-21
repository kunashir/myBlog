MyBlog::Application.routes.draw do
  root :to => 'pages#home'
  ActiveAdmin.routes(self)

  #get "storages/new"

  #get "clients/new"

  #get "drivers/new"

  #get "avtos/new"

  #get "companies/new"

  #get "transportations/new"

  resources :users
  resources :sessions, :only => [:new, :create, :destroy]
  resources :transportations do #, :only => [:new, :create, :index ]
    member do
      get 'get_form'
      get 'confirm_abort'
      get 'request_abort'
      get 'abort'
      get 'do_spec_rate'
      get 'do_rate'
    end
    collection do
      get 'export'
      get 'packet_loading'
    end
  end
  resources :companies
  resources :avtos
  resources :drivers
  resources :storages
  resources :clients
  #resources	:rates

  match '/signup',  :to => 'users#new'
  match '/contact', :to => 'pages#contact'
  match '/help',    :to => 'pages#help', :as => :help
  match '/signin',  :to => 'sessions#new', :as => :signin
  match '/signout', :to => 'sessions#destroy'
  match '/index',   :to => 'transportations#index'
  #спец. роутинг для подтверждения заявки
  match 'transportations/:id/confirmation', 	:to 	=>  'transportations#confirmation'
  match 'transportations/:id/edit_conf',    	:to 	=>  'transportations#edit_conf'
  match 'transportations/:id/get_start_sum',  	:to 	=>  'transportations#get_start_sum'
  match 'transportations/:id/get_storage',    :to   =>  'transportations#get_storage'
  match	'transportations/:id/copy',		:to	=>	'transportations#new', :as => :copy_transportation
  #match	'transportations/:id/packet',		:to	=>	'transportations#packet_loading'
  match	'transportations/:id/load',		:to	=>	'transportations#load'
  #match	'transportations/:id/abort',		:to	=>	'transportations#abort'
  #match 'transportations/:id/export',		:to 	=>	'transportations#export'
  match 'transportations/:id/specprice',	:to	=>	'transportations#spec_price'
  #match 'transportations/:id/request_abort',	:to	=>	'transportations#request_abort'
  #match 'transportations/:id/confirm_abort',	:to	=>	'transportations#confirm_abort'
  match 'transportations/:id/server_time',	:to	=>	'transportations#server_time'
  #match 'transportations/:id/do_rate',	:to	=>	'transportations#do_rate'
  #match 'transportations/:id/do_spec_rate',	:to	=>	'transportations#do_spec_rate'
  match 'users/:id/read_reg', :to => 'users#read_reg'
  #match '/home', :to => 'pages#home'



end
