# frozen_string_literal: true

require "rails_helper"

module FloodRiskEngine
  RSpec.describe NewRegistration do
    subject { build(:new_registration, workflow_state: "partner_name_form") }

    describe "#workflow_state" do
      context ":partner_name_form state transitions" do
        context "on next" do
          include_examples "has next transition", next_state: "partner_postcode_form"
        end

        context "on back" do
          context "when the registration has existing partners" do
            before { expect(subject).to receive(:existing_partners?).and_return(true) }

            include_examples "has back transition", previous_state: "partner_overview_form"
          end

          include_examples "has back transition", previous_state: "business_type_form"
        end
      end
    end
  end
end
