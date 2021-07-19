Rails.application.routes.draw do

  resources :anonymous_inquiries, path: 'contact_us', only: [:new, :create]

  resources :inquiries, only: [:new, :create] do 
    post 'premium', to: 'inquiries#premium', on: :collection
  end 

  resource :subscription, only: [:show]
  get 'plans/show'

  get 'errors/not_found'
  get 'errors/internal_server_error'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  get 'help', to: 'pages#help', as: 'pages_help'
  get 'health', to: 'pages#health', as: 'pages_health'
  post 'search', to: 'search#index'

  resources :notes, param: :guid do
    get '/network_data', to: 'notes#network_data', on: :member
    get '/make_public', to: 'notes#make_public', on: :member
    get '/make_private', to: 'notes#make_private', on: :member
    get '/make_included_in_dg', to: 'notes#make_included_in_dg', on: :member
    delete '/attachment/:id', to: 'notes#delete_attachment', on: :member, as: :delete_attachment
  end

  get '/public/:guid', to: 'notes#public', params: :guid, as: :public_note
  get '/g/:slug', to: 'digital_gardens#show_public', as: :g

  resources :digital_gardens, param: :slug

  devise_for :users, controllers: {
    registrations: "registrations",
    passwords: "passwords",
    omniauth_callbacks: "users/omniauth_callbacks" }

  resources :categories, param: :slug
  resources :tags, param: :name

  # INBOX
  get '/inbox', to: 'categories#show', as: :inbox, defaults: {slug: :inbox}
  get '/inbox/new', to: 'notes#new', as: :new_inbox_item, defaults: {slug: :inbox}

  # PROJECTS
  get '/projects', to: 'categories#show', as: :projects, defaults: {slug: :projects}
  get '/project/new', to: 'categories#new', as: :new_project, defaults: {slug: :project}
  post '/projects', to: 'categories#create', defaults: {slug: :project}
  get '/projects/:slug', to: 'categories#show', as: :project
  get '/projects/:slug/edit', to: 'categories#edit', as: :edit_project
  patch '/projects/:slug', to: 'categories#update'

  get '/wiki', to: 'categories#wiki'
  get '/download', to: 'downloads#export_zip', as: 'download_export_zip'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root to: "dashboard#index"
  root to: "pages#index"

  if Rails.env.development?
    require 'sidekiq/web'
    require 'sidekiq-status/web'
    authenticate :user do
      mount Sidekiq::Web => '/sidekiq'
    end
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  direct :official_github_repo do
    "https://github.com/chrisvel/wreeto_official"
  end

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  # get '*unmatched_route', to: 'application#not_found'
end
