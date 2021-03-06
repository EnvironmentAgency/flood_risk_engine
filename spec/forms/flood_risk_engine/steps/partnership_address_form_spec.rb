require "rails_helper"
require_relative "../../../support/shared_examples/form_objects"
require_relative "../../../support/asserts"

module FloodRiskEngine
  module Steps

    RSpec.describe PartnershipAddressForm do
      let(:params_key) { :partnership_address }
      let(:enrollment) do
        enrollment = FactoryBot.create(:enrollment, :with_partnership, :with_address_search)
        contact = FactoryBot.create(:contact)
        FactoryBot.create(
          :partner,
          contact: contact,
          organisation: enrollment.organisation
        )
        enrollment
      end
      let(:model_class) { FloodRiskEngine::Address }
      let(:form) { described_class.factory(enrollment) }
      let(:postcode) { "BS1 5AH" }
      let(:uprn) { "340116" }
      let(:params) { { form.params_key => { postcode: postcode, uprn: uprn } } }

      subject { form }

      before(:each) { VCR.insert_cassette("address_lookup_valid_postcode", allow_playback_repeats: true) }
      after(:each) { VCR.eject_cassette }

      it_behaves_like "a form object"

      it "is not redirectable" do
        expect(form.redirect?).to_not(be_truthy)
      end

      describe "#validate" do
        context "with valid params" do
          it "returns true" do
            expect(form.validate(params)).to eq(true)
          end
        end
      end

      describe "#save" do
        let(:address) { subject.partner.reload.contact.address }

        before do
          form.validate(params)
          expect(form.save).to eq true
        end

        it "saves a valid address on enrollment" do
          expected_attributes = {
            address_type: "primary",
            premises: "HORIZON HOUSE",
            street_address: "DEANERY ROAD",
            locality: nil,
            city: "BRISTOL",
            postcode: postcode,
            uprn: uprn
          }

          assert_record_values address, expected_attributes
        end
      end

      describe "#partner" do
        it "should match the last partner" do
          expect(form.partner).to eq(enrollment.reload.partners.last)
        end

        context "when more than one partner present" do
          before do
            contact = FactoryBot.create(:contact)
            @partner = FactoryBot.create(
              :partner,
              contact: contact,
              organisation: enrollment.organisation
            )
          end

          it "should match the latest partner" do
            expect(form.partner).to eq(@partner)
          end
        end
      end

      describe "#no_header_in_show" do
        it "should be true" do
          expect(form.no_header_in_show).to eq(true)
        end
      end
    end
  end
end
