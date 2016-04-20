FactoryGirl.define do
  factory :organisation, class: "FloodRiskEngine::Organisation" do
    org_type :other
    name Faker::Company.name
    contact_id 1
    company_number Faker::Number.number(8)
  end
end
