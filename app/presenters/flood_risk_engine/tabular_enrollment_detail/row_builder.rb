module FloodRiskEngine
  module TabularEnrollmentDetail
    class RowBuilder
      include Engine.routes.url_helpers
      attr_reader :enrollment, :i18n_scope, :display_change_url
      delegate :organisation_type, to: :enrollment_presenter

      # enrollment:         the enrollment
      # i18n_scope:         a locale key under which we expect to find row titles etc
      # display_change_url: true for the check your details page, false for confirmation email
      def initialize(enrollment:, i18n_scope:, display_change_url:)
        @enrollment = enrollment
        @i18n_scope = i18n_scope
        @display_change_url = display_change_url
      end

      def organisation_type_row
        build_row name: :organisation_type,
                  value: organisation_type,
                  display_change_url: false
      end

      def grid_reference_row
        build_row name: :grid_reference,
                  value: enrollment_presenter.grid_reference
      end

      def exemptions_rows
        enrollment.exemptions.map do |exemption|
          exemption_row(exemption)
        end
      end

      def exemption_row(exemption)
        build_row name: :exemption,
                  value: exemption.summary,
                  step: :add_exemptions,
                  code: exemption.code
      end

      def organisation_name_row
        build_row name: :organisation_name,
                  value: enrollment_presenter.organisation_name,
                  step: organisation_type
      end

      def organisation_address_row
        build_row name: :organisation_address,
                  value: enrollment_presenter.organisation_address,
                  step: "#{organisation_type}_address"
      end

      def correspondence_contact_name_row
        build_row name: :correspondence_contact_name,
                  value: enrollment_presenter.correspondence_contact_name
      end

      def correspondence_contact_email_row
        build_row name: :correspondence_contact_email,
                  value: enrollment_presenter.correspondence_contact_email_address
      end

      def correspondence_contact_telephone_row
        build_row name: :correspondence_contact_telephone,
                  value: enrollment_presenter.correspondence_contact_telephone_number
      end

      private

      # ==== Arguments
      # * +name+ -used as:
      #   * a data-xxx attribute in the markup for the row (to aid testing)
      #   * the locale key under which e.g. the row :title is found
      #   * the step name if none supplied
      # * +value+   - the value
      # * +step+    - the step name if different form the :name
      # * +display_change_url+ - hide the url if false - for example if this row's value
      #            cannot be changed. Defaults to the instance default (see initializer)
      # * +t_options+ - a hash passed to t() calls e.g. for variable interpolation
      def build_row(name:,
                    value:,
                    step: nil,
                    display_change_url: @display_change_url,
                    **t_options)
        step ||= name
        Row.new(
          name: name,
          title: row_t(name, :title, t_options),
          value: value,
          change_url: (url_for_step(step) if display_change_url),
          change_link_suffix: row_t(name, :accessible_change_link_suffix, t_options)
        )
      end

      def url_for_step(step)
        enrollment_step_path(enrollment, step.to_sym)
      end

      def row_t(step, key, opts = {})
        I18n.t!(".rows.#{step}.#{key}", opts.merge(scope: i18n_scope))
      end

      def enrollment_presenter
        @enrollment_presenter ||= EnrollmentPresenter.new(enrollment)
      end
    end
  end
end