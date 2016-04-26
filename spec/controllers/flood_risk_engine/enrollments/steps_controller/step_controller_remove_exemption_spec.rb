require "rails_helper"
module FloodRiskEngine
  describe Enrollments::StepsController, type: :controller do
    routes { Engine.routes }
    render_views
    let(:exemption) { FactoryGirl.create(:exemption) }
    let(:other_exemption) { FactoryGirl.create(:exemption) }
    let(:enrollment) do
      FactoryGirl.create(
        :enrollment,
        step: :check_exemptions,
        exemptions: exemptions
      )
    end

    describe ".remove_exemption" do
      context "when more than one exemptions" do
        let(:exemptions) { [exemption, other_exemption] }

        before do
          get :remove_exemption, id: enrollment, exemption_id: exemption
        end

        describe "removing an exemption" do
          it "should redirect to current step" do
            expect(response).to redirect_to(
              enrollment_step_path(enrollment, enrollment.step)
            )
          end

          it "should remove the exemption" do
            expect(enrollment.reload.exemptions).to eq([other_exemption])
          end
        end
      end

      context "when one exemption" do
        let(:exemptions) { [exemption] }

        before do
          get :remove_exemption, id: enrollment, exemption_id: exemption
        end

        describe "removing an exemption" do
          it "should redirect to previous step" do
            expect(response).to redirect_to(
              enrollment_step_path(enrollment, enrollment.previous_step)
            )
          end

          it "should remove the exemption" do
            expect(enrollment.reload.exemptions).to eq([])
          end
        end
      end
    end
  end
end
