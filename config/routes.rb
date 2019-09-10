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
      resources :business
      get "/search" => "search#index"
      get "/search/:id" => "search#show"
      post "/business/:id/review" => "review#create"
      get "/business/:id/reviews" => "review#index"
      patch "/business/:id/review/:review_id" => "review#update"
    end
  end
end
