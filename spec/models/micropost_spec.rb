require 'rails_helper'

RSpec.describe Micropost, :type => :model do

  # Tests for proper DBL behavior
  it "is valid with content(sms), a named activity, a schedule_time, and belongs to a user" do
    micropost = build(:micropost)
    expect(micropost).to be_valid
  end

  # A task must have SMS content
  it "is invalid without content(sms)" do
    micropost = build(:micropost, content: '  ')
    micropost.valid?
    expect(micropost.errors[:content]).to include("can't be blank")
  end

  # A task must have a named activity
  it "is invalid without a named activity" do
    micropost = build(:micropost, activity: '')
    micropost.valid?
    expect(micropost.errors[:activity]).to include("can't be blank")
  end

  # That task activity can't be less than 5 characters
  it "is invalid if the named activity is less than 5 characters" do
    micropost = build(:micropost, activity: 'abcd')
    micropost.valid?
    expect(micropost.errors[:activity]).to include("is too short (minimum is 5 characters)")
  end

  # That task activity can't be more than 75 characters
  it "is invalid if the named activity is more than 75 characters" do
    micropost = build(:micropost, activity: 'a'*76 )
    micropost.valid?
    expect(micropost.errors[:activity]).to include("is too long (maximum is 75 characters)")
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
