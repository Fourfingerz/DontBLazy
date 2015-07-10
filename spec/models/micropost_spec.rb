require 'rails_helper'

RSpec.describe Micropost, :type => :model do

  # Tests for proper DBL behavior
  it "is valid with content(sms), a schedule_time, and belongs to a user" do
    micropost = build(:micropost)
    expect(micropost).to be_valid
  end

  # A task must have SMS content
  it "is invalid without content(sms)" do
    micropost = build(:micropost, content: '  ')
    micropost.valid?
    expect(micropost.errors[:content]).to include("can't be blank")
  end

  # A task must be scheduled
  it "is invalid without a scheduled time" do
   micropost = build(:micropost, schedule_time: '')
   micropost.valid?
   expect(micropost.errors[:schedule_time]).to include("can't be blank")
  end

  # A task can't be an orphan, it needs an account owner
  it "is invalid without an owner" do
    micropost = build(:micropost, user_id: '')
    micropost.valid?
    expect(micropost.errors[:user_id]).to include("can't be blank")
  end
end
