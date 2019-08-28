Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  namespace :api do
    namespace :v1 do
        get "/auth/github/callback" => "users#lol"
      resources :users
    end
  end
end
