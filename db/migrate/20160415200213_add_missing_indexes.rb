class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :flood_risk_engine_enrollments, :applicant_contact_id
    add_index :flood_risk_engine_enrollments, :organisation_id
    add_index :flood_risk_engine_enrollments, :site_address_id
    add_index :flood_risk_engine_contacts,
              :partnership_organisation_id,
              name: "fre_contacts_partnership_organisation_id"
    add_index :flood_risk_engine_organisations, :contact_id
    add_index :flood_risk_engine_organisations, :type
    add_index :flood_risk_engine_enrollments_exemptions,
              [:enrollment_id, :exemption_id],
              unique: true,
              name: "fre_enrollments_exemptions_enrollment_id_exemption_id"
  end
end
