require 'rails_helper'

RSpec.describe Insurance::RecommendationService, type: :service do
    let(:valid_params) do
        {
          age: 50,
          dependents: 2,
          income: 70000,
          marital_status: "married",
          risk_questions: [ 0, 1, 0 ],
          house: { ownership_status: "owned" },
          vehicle: { year: 2018 }
        }
    end

    describe 'Risk analysis and plan recommendation' do
        context 'When user is old' do
            it 'Should be ineligible for disability and life insurances - Ok response' do
                modified_params = valid_params.merge(age: 65)
                service = ::Insurance::RecommendationService.new(modified_params)
                expect(service.recommend_plans).to include({
                    disability: "inelegivel",
                    life:  "inelegivel"
                })
            end
        end

        context 'When user has no house' do
            it 'Should be ineligible for home insurance - Ok response' do
                modified_params = valid_params.merge(house: nil)
                service = ::Insurance::RecommendationService.new(modified_params)
                expect(service.recommend_plans).to include({
                    home: "inelegivel"
                })
            end
        end

        context 'When user has no vehicle' do
            it 'Should be ineligible for vehicle insurance - Ok response' do
                modified_params = valid_params.merge(vehicle: nil)
                service = ::Insurance::RecommendationService.new(modified_params)
                expect(service.recommend_plans).to include({
                    auto: "inelegivel"
                })
            end
        end

        context 'When user has no income' do
            it 'Should be ineligible for disablity insurance - Ok response' do
                modified_params = valid_params.merge(income: 0)
                service = ::Insurance::RecommendationService.new(modified_params)
                expect(service.recommend_plans).to include({
                    disability: "inelegivel"
                })
            end
        end

        context 'user is young and rich' do
            it 'Should be recommended more economic options - Ok response' do
                modified_params = valid_params.merge(age: 20, income: 300000)
                service = ::Insurance::RecommendationService.new(modified_params)
                expect(service.recommend_plans).to eq({
                    auto: "economico",
                    disability: "economico",
                    home: "economico",
                    life: "economico"
                })
            end
        end
    end
end
