module FloodRiskEngine
  module Steps
    class FormObjectFactory
      class << self
        def form_object_for(step, enrollment)
          klass = form_object_class_map[step.to_sym] || setup_form_object(step)

          raise(FormObjectError, "No form object defined for step #{step}") unless klass

          klass.factory(enrollment)
        end

        # NB: use NullForm for steps with no html form.
        def form_object_class_map
          @form_object_class_map ||= {
            grid_reference:                   Steps::GridReferenceForm,
            review:                           Steps::NullForm,
            add_exemptions:                   Steps::AddExemptionsForm,
            check_exemptions:                 Steps::NullForm,
            user_type:                        Steps::UserTypeForm,
            check_your_answers:               Steps::CheckYourAnswersForm,
            declaration:                      Steps::NullForm
          }
        end

        private

        def setup_form_object(step)
          form_name = "FloodRiskEngine::Steps::#{step.to_s.classify}Form"
          form_name.constantize
        end

      end
    end
  end
end
