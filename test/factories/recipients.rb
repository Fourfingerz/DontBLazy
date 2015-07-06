FactoryGirl.define do
  factory :recipient do
  	name { Faker::Name.name }
  	user_id { 1 }
  	phone { Faker::PhoneNumber.phone_number }
  end

  factory :invalid_recipient do
  	name nil
  end
end

