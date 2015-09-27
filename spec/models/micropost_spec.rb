require 'rails_helper'

RSpec.describe Micropost, :type => :model do

  # Tests for proper DBL behavior
  it "is valid with title, content, a schedule_time, and belongs to a user" do
    micropost = build(:micropost)
    expect(micropost).to be_valid
  end

  # A task must have a title
  it "is invalid without a title" do
    micropost = build(:micropost, title: '')
    micropost.valid?
    expect(micropost.errors[:title]).to include("can't be blank")
  end

  # A task must be scheduled
  it "is invalid without a specified number of days to complete" do
   micropost = build(:micropost, days_to_complete: nil)
   micropost.valid?
   expect(micropost.errors[:days_to_complete]).to include("can't be blank")
  end

  # A task can't be an orphan, it needs an account owner
  it "is invalid without an owner" do
    micropost = build(:micropost, user_id: '')
    micropost.valid?
    expect(micropost.errors[:user_id]).to include("can't be blank")
  end

end
# EXAMPLES OF MODEL METHOD TESTS
#   it "adds to the list of addresses if the student's address changes" do
#   student = build(:student)
#   student.current_address = "first address"
#   student.current_address = "second address"
#   student.addresses.count.should == 2
# end

# Failure/Error: student.addresses.count.should == 2
#      expected: 2
#           got: 1 (using ==)

# it "provides the student's current address" do
#   student = build(:student)
#   student.current_address = "first address"
#   student.current_address = "second address"
#   student.current_address = ""
#   student.current_address.should == "second address"
# end

# Failure/Error: student.current_address.should == "second address"
#      expected: "second address"
#           got: "" (using ==)

# # return the last address from the array
# def current_address
#   addresses && addresses.last
# end

# # add the current address to the array of addresses
# # if the current address is not blank and is not the same as the last address
# def current_address=(value)
#   list = self.addresses
#   list ||= []
#   if !value.empty? && value != list.last
#     list << value
#   end
#   write_attribute(:addresses, list)
# end

