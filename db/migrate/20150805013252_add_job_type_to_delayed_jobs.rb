class AddJobTypeToDelayedJobs < ActiveRecord::Migration
  def change
    add_column :delayed_jobs, :owner_job_type, :string
  end
end
