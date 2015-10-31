require 'rails_helper'

describe User do

  it "should have a valid factory" do
  	expect(build(:user)).to be_valid
  end

  it "is valid with a name, last name, valid email, and phone number" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "will not allow users to make another account with the same phone number" do
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

  it "will not allow users to create account with numbers in either name field" do
    expect(build(:user,
                  name: '3CPO',
                  last_name: 'de Emp1re'
                  ).should_not be_valid
          )
  end

  it "will not allow users to create account with a name that's over 25 characters" do
    expect(build(:user,
                  name: 'YZCxeUbMhiNgapHRTaszMQxrcj',
                  last_name: 'pSsviClrPqwyMeEgpMxfPQiGkw'
                  ).should_not be_valid 
          )
  end

  it "will not allow users to make another account with the same email" do
    first_user = create(:user,
                    email: 'user@dontbelazy.com'
                    )
    second_user = build(:user,
                  email: 'user@dontbelazy.com'
                )
    second_user.valid?
    expect(second_user.errors[:email]).to include('has already been taken')
  end


  # Method testr
  it "user#generate_pin rolls and saves a four digit pin for a user" do
    user = build(:user, phone_pin: nil)
    pin = user.generate_pin

    expect(user.phone_pin).to eq pin
  end

  it "user#verify updates user's phone_verified to TRUE if entered PIN matches database PIN" do
    user = build(:user, phone_pin: 1945)
    user.verify(1945)

    expect(user.phone_verified).to eq true
  end

  it "user#create_status_sms creates the proper tasks map for persistance and proper sms message" do
    user = build(:user)
    first_task  = build(:micropost, user: user)
    second_task = build(:micropost, user: user)

    actual_sms = user.create_status_sms

    heading = 'DontBLazy App: Reply to this message with the corresponding number to mark a task complete. '
    first_task_title = '1 <= ' + first_task.title + '. '
    second_task_title = '2 <= ' + second_task.title + '. '
    reference_sms = heading + first_task_title + second_task_title

    expect(user.current_tasks_map).to eq '{"task"=>1, "micropost id"=>1}, {"task"=>2, "micropost id"=>2}'
    expect(actual_sms).to eq reference_sms
  end

end