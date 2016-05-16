require_dependency "flood_risk_engine/application_controller"

module FloodRiskEngine
  module Enrollments
    class AddressesController < ApplicationController

      def new
        build_address
        check_for_errors
      end

      def create
        build_address
        update
      end

      def edit
        check_for_errors
      end

      def update
        clear_error_params
        redirect_to target_url
      end

      private

      def form
        @form ||= AddressForm.new(enrollment, address)
      end
      helper_method :form

      def target_url
        if save_form!
          step_forward
          enrollment_step_path(enrollment, enrollment.current_step)
        else
          session[:error_params] = {
            address: params[:address]
          }
          failure_url
        end
      end

      def failure_url
        if params[:action] == "create"
          new_enrollment_address_path(
            enrollment,
            postcode: params[:postcode],
            association: params[:association],
            check_for_error: true
          )
        else
          edit_enrollment_address_path(
            enrollment,
            address,
            check_for_error: true
          )
        end
      end

      def save_form!
        return false unless form.validate(params)
        form.save
      end

      def enrollment
        @enrollment ||= Enrollment.find_by_token!(params[:enrollment_id])
      end

      def address
        @address ||= Address.find(params[:id])
      end

      def build_address
        raise "required attributes not found" unless params[:postcode] && params[:association]
        @address = Address.new(postcode: params[:postcode])
        enrollment.send("#{params[:association]}=", @address)
      end

      def step_forward
        enrollment.go_forward
        enrollment.save
      end

      def clear_error_params
        session[:error_params] = {}
      end

      def check_for_errors
        form.validate(session[:error_params]) if params[:check_for_error]
      end
    end
  end
end
