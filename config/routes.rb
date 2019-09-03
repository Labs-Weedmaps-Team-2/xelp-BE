Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  get "/auth/:provider/callback" => "sessions#create"
  get "/logout" => "sessions#destroy"
  namespace :api do
    namespace :v1 do
      get "/users/current_user" => "users#current_user"
      get "/search" => "search#index"
      resources :users
      get "/search" => "search#index"
    end
  end
end
