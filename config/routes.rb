LogisticTender::Application.routes.draw do
  root :to => 'pages#home'
  ActiveAdmin.routes(self)

  # get "logout" => "sessions#destroy", :as => "logout"
  # get "login" => "sessions#new", :as => "login"

  resources :users do
    member do 
      get 'read_reg'
    end
  end
  resources :sessions, :only => [:new, :create, :destroy]
  resources :transportations do #, :only => [:new, :create, :index ]
    member do
      get 'get_form'
      get 'confirm_abort'
      get 'request_abort'
      get 'abort'
      get 'do_spec_rate'
      get 'do_rate'
      get 'show_history'
      get 'copy', to: 'transportations#new', :as => :copy
      patch 'confirmation'
      get 'edit_conf'
    end
    collection do
      get 'chart_data'
      get 'export'
      get 'packet_loading'
      post 'load'
      get 'server_time'
      get 'get_storage'
      get 'get_start_sum'
    end
  end
  resources :companies
  resources :avtos
  resources :drivers
  resources :storages
  resources :clients
  #resources	:rates

  get '/signup',  :to => 'users#new'
  get '/contact', :to => 'pages#contact'
  get '/help',    :to => 'pages#help', :as => :help
  get '/signin',  :to => 'sessions#new', :as => :signin
  delete '/signout', :to => 'sessions#destroy'
  get '/index',   :to => 'transportations#index'
  #спец. роутинг для подтверждения заявки
  # match 'transportations/:id/confirmation', 	:to 	=>  'transportations#confirmation'
  # match 'transportations/:id/edit_conf',      :to   =>  'transportations#edit_conf'
  # match 'transportations/:id/get_start_sum',  	:to 	=>  'transportations#get_start_sum'
  # match 'transportations/:id/get_storage',    :to   =>  'transportations#get_storage'
  # match	'transportations/:id/copy',		:to	=>	'transportations#new', :as => :copy_transportation
  # match	'transportations/:id/load',		:to	=>	'transportations#load'
  # match 'transportations/:id/specprice',	:to	=>	'transportations#spec_price'
  # match 'transportations/:id/server_time',	:to	=>	'transportations#server_time'

  # match 'users/:id/read_reg', :to => 'users#read_reg'
  #match '/home', :to => 'pages#home'

  #match "*", :to => "home#routing_error"


end
