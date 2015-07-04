FactoryGirl.define do

  factory :user do
  	name { Faker::Name.name }
  	email { Faker::Internet.email }
  	password "foobar"
  	password_confirmation "foobar"

  	factory :user_with_recipient do
  	  after(:create) do |user|
  	  	create(:recipient, user: user)
  	  end
  	end

    factory :user_with_invalid_recipient do
      after(:create) do |user|
        create(:recipient, user: user, 
                name: nil)
      end
    end
  end
end


