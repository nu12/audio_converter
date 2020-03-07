Rails.application.routes.draw do
  root to: "welcome#index"
  get 'welcome/index'
  post "/welcome/upload/:id", to: "welcome#upload"
  post "/welcome/convert/:id", to: "welcome#convert"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
