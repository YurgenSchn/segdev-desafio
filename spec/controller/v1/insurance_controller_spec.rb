require 'rails_helper'

RSpec.describe V1::InsuranceController, type: :controller do
  let(:valid_params) do
    {
      age: 35,
      dependents: 2,
      income: 0,
      marital_status: "married",
      risk_questions: [ 0, 1, 0 ],
      house: { ownership_status: "owned" },
      vehicle: { year: 2018 }
    }
  end

  describe "GET /recommended_plans" do
    context 'Invalid Requests' do
      it 'Invalid risk questionaire array - Error Response' do
          modified_params = valid_params.merge(risk_questions: [ "1", "2" ])
          get :recommended_plans, params: modified_params, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to include("errors")
      end

      it 'Invalid house - Error Response' do
          modified_params = valid_params.merge(house: { acquisition_date: 2024-03-12 })
          get :recommended_plans, params: modified_params, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to include("errors")
      end

      it 'Invalid vehicle - Error Response' do
          modified_params = valid_params.merge(vehicle: { acquisition_date: 2024-03-12 })
          get :recommended_plans, params: modified_params, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to include("errors")
      end

      it 'Invalid marital status - Error Response' do
          modified_params = valid_params.merge(marital_status: "complicado")
          get :recommended_plans, params: modified_params, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to include("errors")
      end
    end


    context 'Valid Requests'
      it "Success response - recommends correct plans" do
        get :recommended_plans, params: valid_params, as: :json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({
          "auto" => "economico",
          "disability" => "inelegivel",
          "home" => "economico",
          "life" => "padrao"
        })
      end
    end
  end
