Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  post 'search', to: 'search#index'

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

  root to: "notes#index"

  if Rails.env.development?
    require 'sidekiq/web'
    require 'sidekiq-status/web'
    authenticate :user do
      mount Sidekiq::Web => '/sidekiq'
    end
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  get '*unmatched_route', to: 'application#not_found'
end
