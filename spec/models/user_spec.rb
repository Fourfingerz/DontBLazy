require 'rails_helper'

describe User do

  it "should have a valid factory" do
  	expect(build(:user)).to be_valid
  end

  it "is valid with a name, last name, valid email, and phone number" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "will not allow users to make another account with the same phone number" do
    user = create(:user)
    create(:user,
      id: 1,
      phone_number: '17180000000'
      )
    another_phone = build(:user,
      id: 2,
      phone_number: '17180000000'
      )
    another_phone.valid?
    expect(another_phone.errors[:phone_number]).to include('has already been taken')
  end

  it "will not allow users to create account with numbers in either name field" do
    expect(build(:user,
                  name: '3CPO',
                  last_name: 'de Emp1re'
                  ).should_not be_valid
                )
  end

  it "will not allow users to create account with a name that's over 50 characters" do
    expect(build(:user,
                  name: 'YZCxeUbMhiNgapHRTaszMQxrcj',
                  last_name: 'pSsviClrPqwyMeEgpMxfPQiGkw'
                  ).should_not be_valid 
              )
  end

  it "will not allow users to make another account with the same email"
    first_user = create(:user,
                    email: 'user@dontbelazy.com'
                    )
    second_user = build(:user,
                  email: 'user@dontbelazy.com'
                )
    second_user.valid?
    expect(second_user.errors[:email]).to include('has already been taken')
  end
  
end