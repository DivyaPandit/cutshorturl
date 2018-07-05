Rails.application.routes.draw do
  root "home#index"

  resources :resource_locators

  get "/:mini_url" => "resource_locators#show"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
