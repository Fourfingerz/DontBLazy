FactoryGirl.define do

  factory :micropost_recipient do
    association :micropost
    association :recipient
  end

  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password "foobar"
    password_confirmation "foobar"
    activated true
  end

  factory :micropost do
    activity { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence }
    schedule_time { Time.now }
    user_id { 1 }

    factory :micropost_with_recipients do
      ignore do 
        recipients_count 1
      end

      after(:create) do |micropost, evaluator|
        create_list(:micropost_recipient, evaluator.recipients_count, micropost: micropost)
      end
    end
  end

  factory :recipient do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number }
    user_id { 1 }

    factory :recipient_with_microposts do
      ignore do 
        microposts_count 1
      end

      after(:create) do |recipient, evaluator|
        create_list(:micropost_recipient, evaluator.microposts_count, recipient: recipient)
      end
    end
  end
end