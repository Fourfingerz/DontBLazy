require 'rails_helper'

describe Recipient do
  it "is valid with a name, phone, and belongs to a user" do
  	recipient = Recipient.new(
  	  name: 'Beth Gibbons',
  	  phone: '1234567890',
  	  user_id: '89')
  	expect(recipient).to be_valid
  end

  it "is invalid without a name" do
  	recipient = Recipient.new(name: nil)
  	recipient.valid?
  	expect(recipient.errors[:name]).to include("can't be blank")
  end

  it "is invalid with a name shorter than three characters" do
  	recipient = Recipient.new(name: 'Bo')
  	recipient.valid?	
  	expect(recipient.errors[:name]).to include("too short")
  end

  it "is invalid without a phone" do
  	recipient = Recipient.new(phone: '')
  	recipient.valid?
  	expect(recipient.errors[:phone]).to include("can't be blank")
  end

  it "is invalid with a duplicate phone" do
    Recipient.create(
      name: 'Johnny', phone: '12345678')
    recipient = Recipient.new(
      name: 'Mary-Beth', phone: '12345678')
    recipient.valid?
    expect(recipient.errors[:phone]).to include("has already been taken")
  end

  it "is invalid if it doesn't belong to a user" do
    recipient = Recipient.new(user_id: '')
    recipient.valid?
    expect(recipient.errors[:user_id]).to include("can't be blank")
  end
end