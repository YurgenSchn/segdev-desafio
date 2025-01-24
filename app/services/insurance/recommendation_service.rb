class Insurance::RecommendationService
    
    include ActiveModel::Validations
  
    attr_reader :data
  
    validates :age, numericality: { greater_than_or_equal_to: 0, only_integer: true }
    validates :dependents, numericality: { greater_than_or_equal_to: 0, only_integer: true }
    validates :income, numericality: { greater_than_or_equal_to: 0, only_integer: true }
    validates :marital_status, inclusion: { in: %w[single married] }
    validate :validate_risk_questions
    validate :validate_house_ownership
    validate :validate_vehicle_year
    
    #===================================#

    def initialize(params)
        @data = params.to_h.transform_keys(&:to_sym)
    end
    
    def valid? # override of ActiveModel::Validations
        @data && super
    end


    def recommend_plans
        return {} unless valid?

        {
            auto: recommended_plan(risk_analysis_auto),
            disability: recommended_plan(risk_analysis_disability),
            home: recommended_plan(risk_analysis_home),
            life: recommended_plan(risk_analysis_life)
        }
    end

    #===================================#
    private

    def base_score
        @base_score ||= begin

            score = risk_questions.sum

            score -= 2 if age < 30
            score -= 1 if age >= 30 && age < 40
            score -= 1 if income > 200_000

            score
        end
    end


    def risk_analysis_auto
        return unless data[:vehicle]

        risk = base_score
        risk += 1 if Time.current.year - data.dig(:vehicle, :year).to_i <= 5

        risk
    end


    def risk_analysis_disability
        return if income == 0
        return if age > 60

        risk = base_score
        risk += 1 if data.dig(:house, :ownership_status) == "rented"
        risk += 1 if dependents > 0
        risk -= 1 if marital_status == "married"

        risk
    end
    

    def risk_analysis_home
        return unless data[:house]

        risk = base_score
        risk += 1 if data.dig(:house, :ownership_status) == "rented"

        risk
    end


    def risk_analysis_life
        return if age > 60

        risk = base_score
        risk += 1 if dependents > 0
        risk += 1 if marital_status == "married"

        risk
    end

    # CONVERTS RISK INTO PLAN
    def recommended_plan(risk)
        return "inelegivel" if risk.nil?
        return "economico" if risk <= 0
        return "padrao" if risk == 1 || risk == 2
        return "avancado" if risk >= 3
    end

    # METHODS TO ACCESS DATA ATTRIBUTES
    def age
        @age ||= data[:age].to_i
    end

    def dependents
        @dependents ||= data[:dependents].to_i
    end

    def income
        @income ||= data[:income].to_i
    end

    def marital_status
        @marital_status ||= data[:marital_status].to_s.strip
    end

    def risk_questions
        @risk_questions ||= Array(data[:risk_questions]).map{ |item| item.to_i }
    end

    # VALIDATION METHODS
    def validate_house_ownership
        return unless data.dig(:house)
        return errors.add(:house, "missing house information") unless data.dig(:house, :ownership_status)         
        return errors.add(:house, "ownership_status should be 'owned' or 'rented'") unless %w[owned rented].include?(data.dig(:house, :ownership_status))
    end
      
    def validate_vehicle_year
        return unless data.dig(:vehicle)
        return errors.add(:vehicle, "missing vehicle information") unless data.dig(:vehicle, :year) 
        year = data[:vehicle][:year]
        return errors.add(:vehicle, "year must be an integer") unless Integer(year, exception: false)
        return errors.add(:vehicle, "year must be positive") unless year.to_i >= 0
    end

    def validate_risk_questions
        errors.add(:risk_questions, "must be an array of 3 integers") unless (data[:risk_questions] && data[:risk_questions].size == 3 && data[:risk_questions].all? { |a| a.is_a?(Integer) })
    end
end