class GetRecommendedPlansSchema
  Schema = Dry::Schema.Params do
    required(:age).filled(:integer, gteq?: 0)
    required(:dependents).filled(:integer, gteq?: 0)
    required(:income).filled(:integer, gteq?: 0)
    required(:marital_status).filled(:string, included_in?: %w[single married])
    required(:risk_questions).filled(:array, size?: 3).each(:integer)

    optional(:house).hash do
      required(:ownership_status).filled(:string, included_in?: %w[owned rented])
    end

    optional(:vehicle).hash do
      required(:year).filled(:integer, gt?: 1900)
    end
  end

  def self.call(params)
    Schema.call(params)
  end
end
