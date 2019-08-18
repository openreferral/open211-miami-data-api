Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # TODO add an apis.json as root

  get 'datapackage', to: 'datapackage#show'
end
