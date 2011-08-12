Iceberg::Application.routes.draw do
  root                         :to => "welcome#index"
  match 'routers'            , :to => 'router#index'
  match 'router/:id/:command', :to => 'router#show'
  match 'step/:id'           , :to => 'step#show'
end
