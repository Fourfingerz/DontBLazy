class RemoveMicropostIdFromDelayedJobs < ActiveRecord::Migration
  def change
    remove_column :delayed_jobs, :micropost_type, :string
    remove_column :delayed_jobs, :micropost_id, :integer
  end
end
