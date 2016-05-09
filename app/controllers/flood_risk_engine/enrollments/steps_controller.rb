# This controller is responsible for the progressive 'building' of an
# enrollment. This has a couple of advantages over using custom get
# and patch routes to target enrollments_controller#edit and #update:
# - clearer separation of concerns
# - leaves EnrollmentsController free for more conventional use
# - 'steps' map to 'views' naturally e.g. app/views/enrollments/steps
# - more RESTful e.g. enrollments/123/steps/step1
#
module FloodRiskEngine
  module Enrollments
    class StepsController < ApplicationController
      class StepError < StandardError; end
      rescue_from StepError, with: :step_not_found
      before_action :check_step_is_valid
      before_action :back_button_cache_buster

      def show
        form.validate(params) if params[:check_for_error]
        render :show, locals: locals
      end

      def update
        logger.debug("In Update - calling Save")
        success = save_form!
        if form.redirect?
          redirect_to(form.redirection_url)
        elsif success
          step_forward
          redirect_to step_url
        else
          logger.error("Form did not Save #{form.errors.inspect}")
          redirect_to failure_url
        end
      end

      private

      def step
        @step ||= params.fetch(:id).to_sym
      end

      def step_url(extra = {})
        enrollment_step_path(enrollment, enrollment.current_step, extra)
      end

      def failure_url
        step_url(
          form.params_key => params[form.params_key],
          check_for_error: true
        )
      end

      def check_step_is_valid
        return true if step_is_current?
        return step_back if step_back_is_possible?
        raise StepError, "Requested #{step}, is not permitted when enrollment.step is #{enrollment.current_step}"
      end

      def step_back_is_possible?
        enrollment.previous_step? step
      rescue StateMachineError
        false
      end

      def step_forward
        logger.error("Form Saved - step_forward from Current [#{enrollment.step}] [#{enrollment.current_step}]")
        byebug
        enrollment.go_forward
        logger.error("Go Forward called state now [#{enrollment.step}] [#{enrollment.current_step}]")
        enrollment.save
      end

      def step_back
        enrollment.go_back
        enrollment.save
      end

      def step_is_current?
        step.to_s == enrollment.current_step.to_s
      end

      def save_form!
        return false unless form.validate(params)
        return false unless enrollment.save
        form.save
      end

      # Using the approach that all vars are passed explicitly to the template
      # rather than relying on exposing @vars which, lets face it, is not great.
      def locals
        {
          form: form,
          step: step
        }
      end

      # Delegate instantiation of the form object to an abstract factory
      def form
        @form ||= Steps::FormObjectFactory.form_object_for(step, enrollment)
      end

      def enrollment
        @enrollment ||= Enrollment.find(params[:enrollment_id])
      end

      def step_not_found
        Rails.logger.info "Step Mismatch: :#{step} requested when enrollment at :#{enrollment.step}"
        redirect_to step_url
      end
    end
  end
end
