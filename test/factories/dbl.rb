FactoryGirl.define do

  factory :recipient do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number }
    user_id { 1 }
  end

  factory :micropost do
    activity { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence }
    user_id { 1 }
  end

  factory :user do
  	name { Faker::Name.name }
  	email { Faker::Internet.email }
  	password "foobar"
  	password_confirmation "foobar"
    activated true

    trait :with_micropost do
      ignore do 
        number_of_microposts 5
      end

      after(:build) do |micropost, evaluator|
        create_list(:micropost, evaluator.number_of_microposts, user: user)
      end
    end

    trait :with_recipients do
      ignore do
        number_of_recipients 3
      end

      after(:create) do |micropost|
        user.recipients = create_list(:recipient, 5, user: user)
      end
    end

    trait :with_the_works do
      with_micropost
      with_recipient
    end

    # Call:
    # User with default 5 microposts and 3 recipients
    # user = FactoryGirl.create(:user, :with_the_works) 

    # User with variable microposts
    # user = create(:user, :with_microposts, number_of_microposts: 7)
  end
end


