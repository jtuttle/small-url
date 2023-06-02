Rails.application.routes.draw do
  apipie

  post '/url/create', to: 'url#create'
  get '/urls', to: 'url#index', format: 'json'
  delete '/url/:url_identifier', to: 'url#destroy'
  
  get '/:token', to: 'url#show'
end
