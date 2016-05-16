require "rails_helper"

module FloodRiskEngine
  module Enrollments
    RSpec.describe AddressesController, type: :controller do
      routes { Engine.routes }
      render_views
      let(:steps) { WorkFlow::Definitions.start }
      let(:step) { steps[1] }
      let(:next_step) { steps[2] }
      let(:enrollment) { FactoryGirl.create(:enrollment, step: step) }
      let(:address) { FactoryGirl.create(:address) }
      let(:postcode) { "S60 1BY" }
      let(:association) { "correspondence_contact_address" }

      describe "new action" do
        before do
          get(
            :new,
            enrollment_id: enrollment,
            postcode: postcode,
            association: association
          )
        end

        it "should render page sucessfully" do
          expect(response).to have_http_status(:success)
        end
      end

      describe "create action" do
        before do
          expect_any_instance_of(AddressForm).to(
            receive(:validate).and_return(validation_result)
          )
          #          expect {
          post(
            :create,
            enrollment_id: enrollment,
            postcode: postcode,
            association: association,
            flood_risk_engine_address: address.attributes.select do |attr, _value|
              [:premises, :street_address, :locality, :city].include? attr
            end
          )
          #          }.to eq(address_count_change).to change("Address.count").by(address_count_change)
        end

        context "on success" do
          let(:validation_result) { true }
          let(:address_count_change) { 1 }

          it "should redirect to the enrollment's next step on success" do
            expect(response).to redirect_to(
              enrollment_step_path(enrollment, next_step)
            )
          end

          it "should create a new address" do
            expect(Address.last.postcode).to eq(postcode)
          end
        end

        context "failure" do
          let(:validation_result) { false }
          let(:address_count_change) { 0 }

          it "should redirect back to new with check for errors" do
            expect(response).to redirect_to(
              new_enrollment_address_path(
                enrollment,
                postcode: postcode,
                association: association,
                check_for_error: true
              )
            )
          end
        end
      end

      describe "show action" do
        before do
          get :edit, id: address, enrollment_id: enrollment
        end

        it "should render page sucessfully" do
          expect(response).to have_http_status(:success)
        end
      end

      describe "update action" do
        before do
          expect_any_instance_of(AddressForm).to(
            receive(:validate).and_return(validation_result)
          )
          put(
            :update,
            id: address,
            enrollment_id: enrollment,
            flood_risk_engine_address: address.attributes
          )
        end

        context "on success" do
          let(:validation_result) { true }

          it "should redirect to the enrollment's next step on success" do
            expect(response).to redirect_to(
              enrollment_step_path(enrollment, next_step)
            )
          end
        end

        context "failure" do
          let(:validation_result) { false }

          it "should redirect back to edit with check for errors" do
            expect(response).to redirect_to(
              edit_enrollment_address_path(enrollment, address, check_for_error: true)
            )
          end
        end
      end
    end
  end
end
