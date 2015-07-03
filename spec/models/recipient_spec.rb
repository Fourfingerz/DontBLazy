require 'rails_helper'

describe Recipient do
  it "has a valid factory" do
  	expect(FactoryGirl.build(:recipient)).to be_valid
  end

  it "is valid with a name, phone, and belongs to a user" do
  	recipient = FactoryGirl.build(:recipient)
  	expect(recipient).to be_valid
  end

  it "is invalid without a name" do
  	recipient = FactoryGirl.build(:recipient, name: '')
  	recipient.valid?
  	expect(recipient.errors[:name]).to include("can't be blank")
  end

  it "is invalid with a name shorter than three characters" do
  	recipient = FactoryGirl.build(:recipient, name: 'Bo')
  	recipient.valid?	
  	expect(recipient.errors[:name]).to include("is too short (minimum is 3 characters)")
  end

  it "is invalid without a phone" do
  	recipient = FactoryGirl.build(:recipient, phone: '')
  	recipient.valid?
  	expect(recipient.errors[:phone]).to include("can't be blank")
  end

  it "is invalid if it doesn't belong to a user" do
    recipient = FactoryGirl.build(:recipient, user_id: '')
    recipient.valid?
    expect(recipient.errors[:user_id]).to include("can't be blank")
  end
end