require 'rails_helper'

describe User do
  # These are DBL phone tests. Rails test suite covers framework functionality.
  it "has a valid factory" do
  	expect(build(:user)).to be_valid
  end

  it "is valid with a name, email, and phone" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "is invalid without a phone" do
    user = build(:user, phone: '')
    user.valid?
    expect(user.errors[:phone]).to include("can't be blank")
  end

  it "does not allow duplicate phone numbers per user" do
    user = create(:user)
    create(:user,
      user_id: rand(100),
      phone: '17180000000'
      )
    another_phone = build(:user,
      user_id: rand(100),
      phone: '17180000000'
      )
    another_phone.valid?
    expect(another_phone.errors[:phone]).to include('has already been taken')
  end

end