Rails.application.routes.draw do
  resources :hosting_periods
  root to: 'dashboards#index'

  # All routes
  get "dashboards/dashboard_4"
  get "dashboards/index"
  get "dashboards/children"
  get "dashboards/children2"
  get "dashboards/child"
  get "dashboards/register"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
