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

end
