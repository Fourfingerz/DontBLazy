class RemoveDayAlreadyCompletedFromMicroposts < ActiveRecord::Migration
  def change
    remove_column :microposts, :day_already_completed, :boolean
  end
end
