FactoryGirl.define do
  factory :user do
  	name { Faker::Name.name }
  	email { Faker::Internet.email }
  	password "foobar"
  	password_confirmation "foobar"

  	after(:build) do |user|
  	  [:name, :phone].each do |recipient|
  	    user.recipients << FactoryGirl.build(:name,
  	      :phone, user: user)
  	  end
  	end
  end
end


