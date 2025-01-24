Rails.application.routes.draw do
  namespace :v1 do
    post 'insurance/recommended-plans', to: 'insurance#recommended_plans'
  end 
end
