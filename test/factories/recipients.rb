FactoryGirl.define do
  factory :recipient do
  	# association :user  # this is fucking up
  	name { Faker::Name.name }
  	user_id { rand(100) }
  	phone { Faker::PhoneNumber.phone_number }
  end
end

