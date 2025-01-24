require 'rails_helper'

RSpec.describe V1::InsuranceController, type: :controller do
  
  describe "GET /recommended_plans" do
    
    let(:valid_params) do
      {
        age: 35,
        dependents: 2,
        income: 0,
        marital_status: "married",
        risk_questions: [0, 1, 0],
        house: { ownership_status: "owned" },
        vehicle: { year: 2018 }
      }
    end
        
    let(:invalid_params) do
      {
         income: -1
      }
    end

    it "Success response - recommends correct plans" do
      post :recommended_plans, params: valid_params, as: :json
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({
        "auto" => "economico",
        "disability" => "inelegivel",
        "home" => "economico",
        "life" => "padrao"
      })
    end

    it "Error response - payload is invalid" do
      get :recommended_plans, params: invalid_params, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to include("errors")
    end
  end
end