require 'rails_helper'

describe User do
  # These are DBL phone tests. Rails test suite covers framework functionality.
  it "has a valid factory" do
  	expect(build(:user)).to be_valid
  end

  it "is valid with a name, email, and phone number" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "users cannot make another account with the same phone number" do
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

end