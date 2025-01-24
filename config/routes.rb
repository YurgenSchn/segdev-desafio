Rails.application.routes.draw do
  namespace :v1 do
    get 'insurance/recommended-plans', to: 'insurance#recommended_plans'
  end 
end
