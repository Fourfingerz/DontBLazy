class AddCheckInToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :check_in_current, :boolean
  end
end
