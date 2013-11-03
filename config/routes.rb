Dave::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users, :controllers => {:sessions => "users/sessions", :registrations => "users/registrations"}
  resources :users
end