class AddPhoneVerificationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone_number, :string
    add_column :users, :phone_pin, :string
    add_column :users, :phone_verified, :boolean
  end
end
