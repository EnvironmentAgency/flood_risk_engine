# frozen_string_literal: true

module FloodRiskEngine
  module CanHaveRegistrationAttributes
    extend ActiveSupport::Concern

    def company_no_required?
      false
    end

    def partnership?
      false
    end

    def address_finder_error
      false
    end

    def company_address
      false
    end
  end
end
