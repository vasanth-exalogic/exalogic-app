Rails.application.routes.draw do

  root "sessions#index"
  post "/sessions" => "sessions#create", as: "new_session"
  get "/sessions" => "sessions#index", as: "sessions"
  get "/logout" => "sessions#index", as: "logout"
  delete "/logout" => "sessions#destroy", as: "signout"

  resources :users

  resources :details, except: [:index, :show, :destroy]
  resources :additionals, except: [:index, :show, :destroy]
  resources :accounts, except: [:index, :show, :destroy]

  resources :percentages, only: [:edit, :update]
  resources :payslips, only: [:create, :show]
  get '/payslips/:id/all' => "payslips#index", as: "all_payslips"
  get '/payslips/new/:id' => "payslips#new", as: "new_payslip"
  get "payslips" => "users#index"
  delete '/delete/payslip/:id' => "payslips#destroy", as: "delete_payslip"
end
