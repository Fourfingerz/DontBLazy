class AddUserIdToDelayedJobs < ActiveRecord::Migration
  def change
    add_column :delayed_jobs, :user_id, :integer
  end
end
