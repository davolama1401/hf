Hf::Application.routes.draw do
  root to: 'home#index'

  scope "/api" do
    resources :properties, constraints: {format: 'json'}, only: [:index, :show] 
  end

  # catch all route which always defers to backbone
  match '*path' => 'home#index', constraints: {format: 'html'}

end
