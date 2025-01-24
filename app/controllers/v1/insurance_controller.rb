class V1::InsuranceController < ApplicationController

    def recommended_plans
        insurance_service = ::Insurance::RecommendationService.new(insurance_params)

        if insurance_service.valid?
          render json: insurance_service.recommend_plans, status: :ok
        else
          render json: { errors: insurance_service.errors.full_messages }, status: :unprocessable_entity
        end
    end


    # ================================ 
    private

    def insurance_params
        params.permit(
          :age,
          :dependents,
          :income,
          :marital_status,
          risk_questions: [],
          house: [:ownership_status],
          vehicle: [:year]
        )
    end

end
