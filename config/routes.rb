Rails.application.routes.draw do

  root "notes#index"

  post 'search', to: 'search#index'
  get 'help', to: 'pages#help', as: 'pages_help'

  resources :notes, param: :guid do
    get '/make_public', to: 'notes#make_public', on: :member
    get '/make_private', to: 'notes#make_private', on: :member
  end

  get '/public/:guid', to: 'notes#public', params: :guid, as: :public_note

  devise_for :users, controllers: {
    registrations: "registrations",
    passwords: "passwords",
    omniauth_callbacks: "omniauth_callbacks" }

  resources :categories
  resources :tags, param: :name

  get '/wiki', to: 'categories#wiki'
  get '/download', to: 'downloads#export_zip', as: 'download_export_zip'

  if Rails.env.development?
    require 'sidekiq/web'
    require 'sidekiq-status/web'
    authenticate :user do
      mount Sidekiq::Web => '/sidekiq'
    end
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # Direct URLs
  direct :official_homepage_repo do
    "https://wreeto.com"
  end
  direct :official_github_repo do
    "https://github.com/chrisvel/wreeto_official"
  end

  get '*unmatched_route', to: 'application#not_found'
end
