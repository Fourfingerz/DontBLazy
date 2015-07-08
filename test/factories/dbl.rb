FactoryGirl.define do

  factory :user do
  	name { Faker::Name.name }
  	email { Faker::Internet.email }
  	password "foobar"
  	password_confirmation "foobar"
  end

  factory :micropost do
    activity { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence }
  end

  factory :recipient do
    name { Faker::Name.name }
    user_id { 1 }
    phone { Faker::PhoneNumber.phone_number }
  end

  factory :invalid_recipient do
    name nil
  end

  factory :micropost_recipient do
    micropost_id 1
    recipient_id 1
  end

end


