Rails.application.routes.draw do
  get '/urls', to: 'url#index', format: 'json'
  post '/url/create', to: 'url#create'
  delete '/url/:url_identifier', to: 'url#destroy'
  
  get '/:token', to: 'url#show'
end
