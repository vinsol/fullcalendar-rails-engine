FullcalendarEngine::Engine.routes.draw do
  root :to => 'events#index'
  resources :events do 
    collection do 
      get :get_events
      post :move
      post :resize
    end
  end
end
