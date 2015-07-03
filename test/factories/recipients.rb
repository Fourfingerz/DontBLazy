FactoryGirl.define do
  factory :recipient do
  	name { Faker::Name.name }
  	user_id { rand(100) }
  	phone { Faker::PhoneNumber.phone_number }
  end
end

