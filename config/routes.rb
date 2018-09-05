Rails.application.routes.draw do
  root to: 'dashboards#index'

  # All routes
  get "dashboards/dashboard_4"
  get "dashboards/index"
  get "dashboards/children"
  get "dashboards/child"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
