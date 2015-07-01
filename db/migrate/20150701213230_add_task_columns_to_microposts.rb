class AddTaskColumnsToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :activity, :string
    add_column :microposts, :schedule_time, :datetime
    add_column :microposts, :delayed_job_id, :integer
    add_column :microposts, :completed, :boolean
  end
end
