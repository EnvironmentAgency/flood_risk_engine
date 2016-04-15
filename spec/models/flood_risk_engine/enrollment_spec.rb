require "rails_helper"

module FloodRiskEngine
  RSpec.describe Enrollment, type: :model do
    before(:all) do
      Enrollment.state_machine_class = TestStateMachine
    end
    after(:all) do
      Enrollment.state_machine_class = nil
    end

    let(:enrollment) { create(:enrollment) }
    let(:steps) { %w[step1 step2 step3] }
    let(:initial_step) { steps[0] }

    it { is_expected.to belong_to(:applicant_contact) }
    it { is_expected.to belong_to(:organisation) }
    it { is_expected.to belong_to(:site_address).class_name("FloodRiskEngine::Address") }

    describe "intializing an instance" do
      context "with a new instance" do
        it "should have the current step set as the initial step" do
          expect(enrollment.current_step).to eq(initial_step)
        end
      end

      context "with a saved instance" do
        let(:enrollment) { create(:enrollment, step: steps[1]) }
        it "should have current step matching the saved step" do
          expect(enrollment.current_step).to eq(steps[1])
        end
      end
    end

    describe ".go_forward" do
      it "should not preserve the current step without save" do
        enrollment.go_forward
        enrollment.reload
        expect(enrollment.step).to eq(initial_step)
      end
    end

    describe ".set_step_as" do
      context "with valid step" do
        let(:new_step) { steps[2] }
        before do
          enrollment.set_step_as new_step
        end
        it "should change the current step to the new step" do
          expect(enrollment.current_step).to eq(new_step)
        end
        it "should not preserve the change" do
          enrollment.reload
          expect(enrollment.step).to eq(initial_step)
        end
        it "should preserve the change if saved" do
          enrollment.save
          expect(enrollment.step).to eq(new_step)
        end
      end
      context "with unknown step" do
        let(:new_step) { "unknown" }
        it "should make the enrollment invalid" do
          enrollment.set_step_as new_step
          expect(enrollment.invalid?).to eq(true)
          expect(enrollment.errors.include?(:step)).to eq(true)
        end
      end
    end
  end
end
