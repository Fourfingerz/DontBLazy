class RemoveScheduleTimeFromMicroposts < ActiveRecord::Migration
  def change
    remove_column :microposts, :schedule_time, :datetime
  end
end
