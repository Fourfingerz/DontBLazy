FactoryGirl.define do
  factory :recipient do
  	name "Zadie Smith"
  	sequence(:phone) { |n| "12345678{n}"}
  end
end