Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  get "/auth/:provider/callback" => "sessions#create"
  get "/auth/logout" => "sessions#destroy"
  namespace :api do
    namespace :v1 do
      get "/users/current_user" => "users#current_user"
      resources :users
      resources :business
      get "/search" => "search#index"
      get "/search/autocomplete" => "search#autocomplete"
      get "/search/:id" => "search#show"
      post "/business/:id/review" => "review#create"
      get "/business/:id/reviews" => "review#index"
#       put "/business/:id/review/:id" => "review#update"
      patch "/reviews/:id" => "review#update"
      delete "/reviews/:id" => "review#destroy"
    end
  end
end
