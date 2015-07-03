FactoryGirl.define do
  factory :recipient do
  	name "Zadie Smith"
  	user_id '89'
  	sequence(:phone) { |n| "12345678{n}"}
  end
end