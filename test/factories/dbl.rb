FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    password "foobar"
    password_confirmation "foobar"
    activated true
    phone_number "0000000000"
    phone_pin "0000"
  end

  factory :micropost do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence }
    schedule_time { Time.current + 2.days }
    user_id { 1 }
  end

  factory :recipient do
    name { Faker::Name.name }
    last_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.phone_number }
    user_id { 1 }
  end

  factory :micropost_recipient do
    ignore do
      user { create(:user) }
    end

    micropost { create(:micropost, user: user) }
    recipient { create(:recipient, user: user) }
  end
end