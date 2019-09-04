Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  get "/auth/:provider/callback" => "sessions#create"
  namespace :api do
    namespace :v1 do
      get "/users/current_user" => "users#current_user"
      resources :users
    end
  end
end
