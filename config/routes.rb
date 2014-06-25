FullcalendarEngine::Engine.routes.draw do
  resources :events do 
    member do
      post :move
      post :resize
    end
  end
  root :to => 'events#index'
end