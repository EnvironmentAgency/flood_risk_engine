FloodRiskEngine::Engine.routes.draw do
  resources :enrollments, only: [:new] do
    resources :steps, only: [:show, :update], controller: "enrollments/steps"
  end
  root to: "enrollments#new"
end
