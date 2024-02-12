Preflex::Engine.routes.draw do
  post 'preferences' => 'preferences#update', as: :preferences
end
