FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    phone_number { '13473063012' }
    password "foobar"
    password_confirmation "foobar"
    activated true
    phone_pin "0000"
    phone_verified true
  end

  factory :micropost do
    title { Faker::Company.bs }
    content { Faker::Lorem.sentence }
    days_to_complete { 5 }
    user_id { 1 }
    active true
  end

  factory :recipient do
    name { Faker::Name.name }
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