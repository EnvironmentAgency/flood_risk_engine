#
# A generalised presenter which adds helpers to simplify accessing enrollment data
# from a view.
#
module FloodRiskEngine
  class EnrollmentPresenter
    delegate :exemption_location, to: :enrollment
    delegate :grid_reference, to: :exemption_location, allow_nil: true

    def initialize(enrollment)
      @enrollment = enrollment
    end

    def organisation_type
      enrollment.org_type.to_sym if enrollment.org_type
    end

    private

    attr_reader :enrollment
  end
end