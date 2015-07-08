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

    trait :with_author do
      user do
        User.find_by(name: "By Sample User") || FactoryGirl.create(:user, name: "Sample User")
      end
    end

    # Call:
    # owned_micropost = FactoryGirl.create(:micropost, :with_author)"
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


