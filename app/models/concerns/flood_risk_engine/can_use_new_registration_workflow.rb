# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
module FloodRiskEngine
  module CanUseNewRegistrationWorkflow
    extend ActiveSupport::Concern

    included do
      include AASM

      aasm column: :workflow_state do
        # States / forms

        # Start
        state :start_form, initial: true

        # Exemptions
        state :exemption_form
        state :confirm_exemption_form

        # Location of activity
        state :site_grid_reference_form

        # Business type
        state :business_type_form

        # Company details
        state :company_number_form
        state :company_name_form
        state :company_postcode_form
        state :company_address_lookup_form
        state :company_address_manual_form

        # Partner details
        state :partner_name_form
        state :partner_postcode_form
        state :partner_address_lookup_form
        state :partner_address_manual_form
        state :manage_partners_form

        # Contact details
        state :contact_name_form
        state :contact_phone_form
        state :contact_email_form
        state :additional_contact_email_form

        # End pages
        state :check_your_answers_form
        state :declaration_form
        state :registration_complete_form

        # Transitions
        event :next do
          # Start
          transitions from: :start_form,
                      to: :exemption_form

          # Exemption
          transitions from: :exemption_form,
                      to: :confirm_exemption_form

          transitions from: :confirm_exemption_form,
                      to: :site_grid_reference_form

          # Location of activity
          transitions from: :site_grid_reference_form,
                      to: :business_type_form

          # Business type
          transitions from: :business_type_form,
                      to: :partner_name_form,
                      if: :should_have_partners?

          transitions from: :business_type_form,
                      to: :company_number_form,
                      if: :should_have_company_number?

          transitions from: :business_type_form,
                      to: :company_name_form
        end

        event :back do
          # Exemption
          transitions from: :exemption_form,
                      to: :start_form

          transitions from: :confirm_exemption_form,
                      to: :exemption_form

          # Location of activity
          transitions from: :site_grid_reference_form,
                      to: :confirm_exemption_form

          # Business type
          transitions from: :business_type_form,
                      to: :site_grid_reference_form
        end
      end
    end

    private

    def should_have_partners?
      partnership?
    end

    def should_have_company_number?
      company_no_required?
    end
  end
end
# rubocop:enable Metrics/BlockLength
