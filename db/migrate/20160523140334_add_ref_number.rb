class AddRefNumber < ActiveRecord::Migration
  def change
    add_column :flood_risk_engine_enrollments, :reference_number, :string, :limit => 12

    add_index :flood_risk_engine_enrollments, [:reference_number], :unique => true
  end
end
