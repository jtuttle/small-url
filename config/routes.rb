Rails.application.routes.draw do
  post '/url/create', to: 'url#create'
  get '/urls', to: 'url#index', format: 'json'
  
  get '/:token', to: 'url#show'
end
