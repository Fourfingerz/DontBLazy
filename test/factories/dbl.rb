FactoryGirl.define do

  factory :user do
  	name { Faker::Name.name }
  	email { Faker::Internet.email }
  	password "foobar"
  	password_confirmation "foobar"

    trait :with_micropost_and_recipient do
      micropost do
        FactoryGirl.create(:micropost, 
                            activity: Faker::Lorem.sentence, 
                            content: Faker::Lorem.sentence
                          )
      end

      recipient do
        FactoryGirl.create(:recipient,
                            name: Faker::Name.name,
                            phone: Faker::PhoneNumber.phone_number
                          )
      end
    end

    # Call:
    # user = FactoryGirl.create(:user, :with_micropost_and_recipient)
  end

  # factory :micropost_recipient do
  #   micropost_id 1
  #   recipient_id 1
  # end

end


