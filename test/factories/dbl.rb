FactoryGirl.define do

  # Vanilla Models

  factory :user do |f|
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password "foobar"
    password_confirmation "foobar"
    activated true
  end

  factory :recipient do |f|
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number }
    user_id { 1 }
  end

  factory :micropost do |f|
    activity { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence }
    user_id { 1 }

    # trait :with_recipients do
    #   ignore do 
    #     number_of_recipients 3
    #   end

    #   after(:create) do |micropost, evaluator|
    #     micropost.recipients = create_list(:recipient, )

  end




  # NOTE: MICROPOSTS 
    # trait :with_microposts do
    #   ignore do 
    #     number_of_microposts 5
    #   end

    #   after(:build) do |user, evaluator|
    #     create_list(:micropost, evaluator.number_of_microposts, user: user)
    #   end
    # end

    # trait :with_recipients do
    #   after(:create) do |user|
    #     user.recipients = create_list(:recipient, 3, user: user)
    #   end
    # end

    # trait :with_the_works do
    #   with_microposts
    #   with_recipients
    # end

    # Call:
    # User with default 5 microposts and 3 recipients:
    # user = FactoryGirl.create(:user, :with_the_works) 

    # User with variable microposts:
    # user = create(:user, :with_microposts, number_of_microposts: 7)
  # end
end


