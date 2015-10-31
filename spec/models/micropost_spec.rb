require 'rails_helper'

RSpec.describe Micropost, :type => :model do

  it "is valid with title, content, a schedule_time, and belongs to a user" do
    micropost = build(:micropost)
    expect(micropost).to be_valid
  end

  it "is invalid without a title" do
    micropost = build(:micropost, title: '')
    micropost.valid?
    expect(micropost.errors[:title]).to include("can't be blank")
  end

  it "is invalid with a title that's over 50 chars or less than 5" do
    short_post = build(:micropost,
                            title: 'vast'
                          )
    long_post  = build(:micropost,
                            title: 'fzqvqvkqh ioltvurl xwogluz xqoo gsrqi vt oqfqgfcbuvz afmj'
                          )
    short_post.valid?
    long_post.valid?
    expect(short_post.errors[:title]).to include("is too short (minimum is 5 characters)")
    expect(long_post.errors[:title]).to include("is too long (maximum is 50 characters)")
  end

  it "is invalid with content that's over 140 characters" do
    long_content = build(:micropost,
                              content: 'svacnngpevyrjgmgkemzqtnnujnyirjwirksuvyojrnzmnfiaivqmpnbyhqvvvvbzxjtcnncaheyxqbossohsqlsavfyouwamuqgxoqgzmabhiiwervxzfuqrnoxsouwwupeeubsfijtq'
                            )
    long_content.valid?
    expect(long_content.errors[:content]).to include("is too long (maximum is 140 characters)")
  end

  it "is invalid without a specified number of days to complete" do
   micropost = build(:micropost, days_to_complete: nil)
   micropost.valid?
   expect(micropost.errors[:days_to_complete]).to include("can't be blank")
  end

  it "is invalid without an user" do
    micropost = build(:micropost, user_id: '')
    micropost.valid?
    expect(micropost.errors[:user_id]).to include("can't be blank")
  end

  # Method testr
  it "micropost#set_initial_state will ready a micropost for mission success" do
   micropost = build(:micropost)
   micropost.set_initial_state

   expect(micropost.check_in_current).to eq false
   expect(micropost.days_completed).to eq 0
   expect(micropost.days_remaining).to eq micropost.days_to_complete
   expect(micropost.current_day).to eq 1
   expect(micropost.active).to eq true
  end

  it "micropost#next_day_dally will increment a micropost for the next day" do
    micropost = build(:micropost)
    micropost.set_initial_state
    micropost.next_day_tally

    expect(micropost.days_remaining).to eq 4
    expect(micropost.current_day).to eq 2
    expect(micropost.check_in_current).to eq false
  end

  it "micropost#inactive_cleanup will clean up any tasks thats not being used"
  it "micropost#send_user_status_sms will send out a Twilio request properly" 
  it "micropost#send_day_completed_sms will send out confirmation that user has task done"
  it "micropost#send_day_incomplete_sms will send out SMS when user misses a daily task"
  it "micropost#send_bad_news_to_buddies will send out SMS to recipients selected for Micropost when user fails a task"
  it "micropost#send_four_hour_reminder will send SMS to user if goal is 4 hours from due_time and user is not checked in"

  it "micropost#check_in will properly check in a micropost depending on whether or not a user checked in" do
    user = build(:user)
    checked_post  = build(:micropost, user: user)
    unchecked_post = build(:micropost, user: user)

    checked_post.set_initial_state
    checked_post.check_in_current = true
    checked_post.check_in
    unchecked_post.set_initial_state
    unchecked_post.check_in

    expect(checked_post.days_completed).to eq 1
    expect(checked_post.days_remaining).to eq 4
    expect(checked_post.current_day).to eq 2
    expect(checked_post.check_in_current).to eq false

    expect(unchecked_post.days_completed).to eq 0
    expect(unchecked_post.days_remaining).to eq 4
    expect(unchecked_post.current_day).to eq 2
    expect(unchecked_post.check_in_current).to eq false
  end
end
