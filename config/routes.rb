Rails.application.routes.draw do
  resources :child_notes
  resources :families
  resources :children
  resources :hosting_session_spot_children
  resources :spot_statuses
  resources :hosting_session_spots
  resources :hosting_sessions
  get 'public/children/:id', to: 'public#children'
  get 'public/child/:id', to: 'public#child'

  root to: 'dashboards#index'

  # All routes
  get "dashboards/dashboard_4"
  get "dashboards/index"
  get "dashboards/children"
  get "dashboards/children2"
  get "dashboards/child"
  get "dashboards/child_adminview"
  get "dashboards/register"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
