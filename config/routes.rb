Rails.application.routes.draw do
  root to: "audio_converter#index"
  get 'audio_converter/index'
  post "/upload", to: "audio_converter#upload"
  post "/convert", to: "audio_converter#convert"
  get "/remove/:original/(:converted)", to: "audio_converter#remove"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
