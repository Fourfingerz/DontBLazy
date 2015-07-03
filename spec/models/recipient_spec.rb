require 'rails_helper'

describe Recipient do
  it "has a valid factory" do
  	expect(build(:recipient)).to be_valid
  end

  it "is valid with a name, phone, and belongs to a user" do
  	recipient = build(:recipient)
  	expect(recipient).to be_valid
  end

  it "is invalid without a name" do
  	recipient = build(:recipient, name: '')
  	recipient.valid?
  	expect(recipient.errors[:name]).to include("can't be blank")
  end

  it "is invalid with a name shorter than three characters" do
  	recipient = build(:recipient, name: 'Bo')
  	recipient.valid?	
  	expect(recipient.errors[:name]).to include("is too short (minimum is 3 characters)")
  end

  it "is invalid without a phone" do
  	recipient = build(:recipient, phone: '')
  	recipient.valid?
  	expect(recipient.errors[:phone]).to include("can't be blank")
  end

  it "is invalid if it doesn't belong to a user" do
    recipient = build(:recipient, user_id: '')
    recipient.valid?
    expect(recipient.errors[:user_id]).to include("can't be blank")
  end

  it "does not allow duplicate phone numbers per user" do
  	recipient = create(:recipient)
  	create(:recipient,
  	  user_id: rand(100),
  	  phone: '17180000000'
  	  )
  	another_phone = build(:recipient,
  	  user_id: rand(100),
  	  phone: '17180000000'
  	  )
  	another_phone.valid?
  	expect(another_phone.errors[:phone]).to include('has already been taken')
  end
end