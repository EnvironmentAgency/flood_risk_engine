require "validates_email_format_of"
require "active_model/validations/confirmation"

module FloodRiskEngine
  module Steps
    class CorrespondenceContactEmailForm < BaseForm

      def self.factory(enrollment)
        super enrollment, factory_type: :correspondence_contact
      end

      def self.params_key
        :correspondence_contact_email
      end

      property :email_address
      property :email_address_confirmation, virtual: true

      # This group manages the main email_address field, confirmation is dependent on results of this group
      #     docs on validation groups :  http://trailblazer.to/gems/reform/validation.html
      #
      validation :email_address_valid? do
        validates :email_address, presence: {
          message: I18n.t("#{CorrespondenceContactEmailForm.locale_key}.errors.email_address.blank")
        }

        validates :email_address, email_format: {
          allow_blank: true,
          message: I18n.t("#{CorrespondenceContactEmailForm.locale_key}.errors.email_address.format")
        }
      end

      # If you want to reach the form to check for errors use unless/if you can via
      #     unless: ->(form) { form.changed?(:email_address) }
      #     unless: ->(form) { form.errors.any? }
      #
      # This reform validation group only runs, if previous email group passed - email_address_valid?
      #
      validation :confirmation_present?, if: :email_address_valid? do
        validates :email_address_confirmation, presence: {
          message: I18n.t("#{CorrespondenceContactEmailForm.locale_key}.errors.email_address_confirmation.blank")
        }
      end

      # The helpers ; allow_blank: true, allow_nil: true  ; only seem to apply to the email_address field
      # not the confirmation, so this format prevents both format & blank messages when conf = blank
      #
      validation :confirmation_matches?, if: :confirmation_present? do
        # Although not specified, Rails automatically validates against a field called email_address_confirmation,
        # See
        # http://api.rubyonrails.org/classes/ActiveModel/Validations/HelperMethods.html#method-i-validates_confirmation_of

        validates :email_address, confirmation: {
          message: I18n.t("#{CorrespondenceContactEmailForm.locale_key}.errors.email_address_confirmation.format")
        }
      end

      def save
        super
        enrollment.correspondence_contact ||= model
        enrollment.save
      end

      # Over ride the reader used in presentation to populate the confirmation field when :
      #   User returns after successful submission - via back or review - because we don't want to force them
      #   to re-enter and re-confirm an already saved email address.
      #
      # N.B This reader used by validations as well as view so care needed as to when to populate field
      #
      def email_address_confirmation
        if no_email_field_changed? && email_present? && no_email_errors?
          Rails.logger.debug("Using existing email for email_address_confirmation")
          enrollment.correspondence_contact.email_address
        else
          # important to use the Reform chain if we dont need the very specific to over ride
          super
        end
      end

      private

      def no_email_field_changed?
        !any_email_field_changed?
      end

      def any_email_field_changed?
        # hash is not indifferent access, use strings
        changed.key?("email_address") || changed.key?("email_address_confirmation")
      end

      def email_present?
        (enrollment&.correspondence_contact && enrollment.correspondence_contact.email_address.present?)
      end

      def no_email_errors?
        (errors.empty? && enrollment.errors.empty? && enrollment.correspondence_contact.errors.empty?)
      end

      # Force use of the factory to create instances of this class
      class << self
        private

        def new(model, enrollment = nil)
          super(model, enrollment)
        end
      end

    end
  end
end
