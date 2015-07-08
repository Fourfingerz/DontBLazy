FactoryGirl.define do

  factory :recipient do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number }
    user_id { 1 }
  end

  factory :micropost do
    activity { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence }
  end

  factory :user do
  	name { Faker::Name.name }
  	email { Faker::Internet.email }
  	password "foobar"
  	password_confirmation "foobar"

    trait :with_micropost_and_recipient do
      micropost do
        FactoryGirl.create(:micropost)
      end

      recipient do
        FactoryGirl.create(:recipient)
      end
    end

    # Call:
    # user = FactoryGirl.create(:user, :with_micropost_and_recipient)
  end
end


