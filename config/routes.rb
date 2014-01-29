IPP::Application.routes.draw do
  resources :rates, only: :index
end
