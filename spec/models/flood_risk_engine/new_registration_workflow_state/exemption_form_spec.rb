# frozen_string_literal: true

require "rails_helper"

module FloodRiskEngine
  RSpec.describe NewRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      previous_state: :start_form,
                      current_state: :exemption_form,
                      next_state: :confirm_exemption_form,
                      factory: :new_registration
    end
  end
end
