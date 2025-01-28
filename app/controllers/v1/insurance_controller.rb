class V1::InsuranceController < ApplicationController
    def recommended_plans
      result = GetRecommendedPlansSchema.call(params.to_unsafe_h)

      if result.success?
        insurance_service = ::Insurance::RecommendationService.new(result.to_h)
        render json: insurance_service.recommend_plans, status: :ok
      else
        render json: { errors: result.errors.to_h }, status: :unprocessable_entity
      end
    end
end
