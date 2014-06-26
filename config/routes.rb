FullcalendarEngine::Engine.routes.draw do
  resources :events do
    collection do
      get :get_events
    end
    member do
      post :move
      post :resize
    end
  end
  root :to => 'events#index'
end