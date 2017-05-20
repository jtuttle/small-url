Rails.application.routes.draw do
  post '/url/create', to: 'url#create'
  get '/:token', to: 'url#show'
end
